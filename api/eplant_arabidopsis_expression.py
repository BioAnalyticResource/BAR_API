#!/usr/bin/env python3
"""
Unified Arabidopsis ePlant expression endpoint.

Replaces ~33 separate XML fetches + N chunked CGI calls per gene load with a
single request. The XML group/tissue/sample structure is baked in (it is static
and never changes per gene). Expression values are fetched from the 14 BAR
databases in parallel, keyed by view so colliding sample names across databases
are handled correctly.

Usage (standalone):
    python3 eplant_arabidopsis.py AT1G01010

Usage (CGI):
    Called as a CGI script; reads ?gene=AT1G01010&species=Arabidopsis from
    QUERY_STRING.

Response shape:
    {
      "gene": "AT1G01010",
      "views": {
        "<viewId>": {
          "<sampleName>": <float value>,
          ...
        },
        ...
      }
    }
"""

import json
import os
import sys
import ssl
import urllib.parse
import urllib.request
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed

# Skip SSL verification — needed when running locally against bar.utoronto.ca.
# On the BAR server itself this context is not required.
_SSL_CTX = ssl.create_default_context()
_SSL_CTX.check_hostname = False
_SSL_CTX.verify_mode = ssl.CERT_NONE

PLANTEFP_BASE = "https://bar.utoronto.ca/eplant/cgi-bin/plantefp.cgi"
CHUNK_SIZE = 50  # samples per CGI request

# ---------------------------------------------------------------------------
# Baked-in view structure (parsed from all Arabidopsis XML files 2026-05-07)
# ---------------------------------------------------------------------------
VIEWS = json.loads(r'''
{
  "atgenexpress": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [
          "ATGE_CTRL_7"
        ],
        "tissues": [
          {
            "name": "Dry seed",
            "id": "Dry_seed",
            "samples": [
              "RIKEN-NAKABAYASHI1A",
              "RIKEN-NAKABAYASHI1B"
            ]
          },
          {
            "name": "Imbibed seed, 24 h",
            "id": "Imbibed_seed_24_h",
            "samples": [
              "RIKEN-NAKABAYASHI2A",
              "RIKEN-NAKABAYASHI2B"
            ]
          },
          {
            "name": "1st Node",
            "id": "1st_Node",
            "samples": [
              "ATGE_28_A2",
              "ATGE_28_B2",
              "ATGE_28_C2"
            ]
          },
          {
            "name": "Flower Stage 12, Stamens",
            "id": "Flower_Stage_12_Stamens",
            "samples": [
              "ATGE_36_A",
              "ATGE_36_B",
              "ATGE_36_C"
            ]
          },
          {
            "name": "Cauline Leaf",
            "id": "Cauline_Leaf",
            "samples": [
              "ATGE_26_A",
              "ATGE_26_B",
              "ATGE_26_C"
            ]
          },
          {
            "name": "Cotyledon",
            "id": "Cotyledon",
            "samples": [
              "ATGE_1_A",
              "ATGE_1_B",
              "ATGE_1_C"
            ]
          },
          {
            "name": "Root",
            "id": "Root",
            "samples": [
              "ATGE_9_A",
              "ATGE_9_B",
              "ATGE_9_C"
            ]
          },
          {
            "name": "Entire Rosette After Transition to Flowering",
            "id": "Entire_Rosette_After_Transition_to_Flowering",
            "samples": [
              "ATGE_23_A",
              "ATGE_23_B",
              "ATGE_23_C"
            ]
          },
          {
            "name": "Flower Stage 9",
            "id": "Flower_Stage_9",
            "samples": [
              "ATGE_31_A2",
              "ATGE_31_B2",
              "ATGE_31_C2"
            ]
          },
          {
            "name": "Flower Stage 10/11",
            "id": "Flower_Stage_10_11",
            "samples": [
              "ATGE_32_A2",
              "ATGE_32_B2",
              "ATGE_32_C2"
            ]
          },
          {
            "name": "Flower Stage 12",
            "id": "Flower_Stage_12",
            "samples": [
              "ATGE_33_A",
              "ATGE_33_B",
              "ATGE_33_C"
            ]
          },
          {
            "name": "Flower Stage 15",
            "id": "Flower_Stage_15",
            "samples": [
              "ATGE_39_A",
              "ATGE_39_B",
              "ATGE_39_C"
            ]
          },
          {
            "name": "Flower Stage 12, Carpels",
            "id": "Flower_Stage_12_Carpels",
            "samples": [
              "ATGE_37_A",
              "ATGE_37_B",
              "ATGE_37_C"
            ]
          },
          {
            "name": "Flower Stage 12, Petals",
            "id": "Flower_Stage_12_Petals",
            "samples": [
              "ATGE_35_A",
              "ATGE_35_B",
              "ATGE_35_C"
            ]
          },
          {
            "name": "Flower Stage 12, Sepals",
            "id": "Flower_Stage_12_Sepals",
            "samples": [
              "ATGE_34_A",
              "ATGE_34_B",
              "ATGE_34_C"
            ]
          },
          {
            "name": "Flower Stage 15, Carpels",
            "id": "Flower_Stage_15_Carpels",
            "samples": [
              "ATGE_45_A",
              "ATGE_45_B",
              "ATGE_45_C"
            ]
          },
          {
            "name": "Flower Stage 15, Petals",
            "id": "Flower_Stage_15_Petals",
            "samples": [
              "ATGE_42_B",
              "ATGE_42_C",
              "ATGE_42_D"
            ]
          },
          {
            "name": "Flower Stage 15, Sepals",
            "id": "Flower_Stage_15_Sepals",
            "samples": [
              "ATGE_41_A",
              "ATGE_41_B",
              "ATGE_41_C"
            ]
          },
          {
            "name": "Flower Stage 15, Stamen",
            "id": "Flower_Stage_15_Stamen",
            "samples": [
              "ATGE_43_A",
              "ATGE_43_B",
              "ATGE_43_C"
            ]
          },
          {
            "name": "Flowers Stage 15, Pedicels",
            "id": "Flowers_Stage_15_Pedicels",
            "samples": [
              "ATGE_40_A",
              "ATGE_40_B",
              "ATGE_40_C"
            ]
          },
          {
            "name": "Leaf 1 + 2",
            "id": "Leaf_1_2",
            "samples": [
              "ATGE_5_A",
              "ATGE_5_B",
              "ATGE_5_C"
            ]
          },
          {
            "name": "Leaf 7, Petiole",
            "id": "Leaf_7_Petiole",
            "samples": [
              "ATGE_19_A",
              "ATGE_19_B",
              "ATGE_19_C"
            ]
          },
          {
            "name": "Leaf 7, Distal Half",
            "id": "Leaf_7_Distal_Half",
            "samples": [
              "ATGE_21_A",
              "ATGE_21_B",
              "ATGE_21_C"
            ]
          },
          {
            "name": "Leaf 7, Proximal Half",
            "id": "Leaf_7_Proximal_Half",
            "samples": [
              "ATGE_20_A",
              "ATGE_20_B",
              "ATGE_20_C"
            ]
          },
          {
            "name": "Hypocotyl",
            "id": "Hypocotyl",
            "samples": [
              "ATGE_2_A",
              "ATGE_2_B",
              "ATGE_2_C"
            ]
          },
          {
            "name": "Young Root",
            "id": "YoungRoot",
            "samples": [
              "ATGE_3_A",
              "ATGE_3_B",
              "ATGE_3_C"
            ]
          },
          {
            "name": "Rosette Leaf 2",
            "id": "Rosette_Leaf_2",
            "samples": [
              "ATGE_12_A",
              "ATGE_12_B",
              "ATGE_12_C"
            ]
          },
          {
            "name": "Rosette Leaf 4",
            "id": "Rosette_Leaf_4",
            "samples": [
              "ATGE_13_A",
              "ATGE_13_B",
              "ATGE_13_C"
            ]
          },
          {
            "name": "Rosette Leaf 6",
            "id": "Rosette_Leaf_6",
            "samples": [
              "ATGE_14_A",
              "ATGE_14_B",
              "ATGE_14_C"
            ]
          },
          {
            "name": "Rosette Leaf 8",
            "id": "Rosette_Leaf_8",
            "samples": [
              "ATGE_15_A",
              "ATGE_15_B",
              "ATGE_15_C"
            ]
          },
          {
            "name": "Rosette Leaf 10",
            "id": "Rosette_Leaf_10",
            "samples": [
              "ATGE_16_A",
              "ATGE_16_B",
              "ATGE_16_C"
            ]
          },
          {
            "name": "Rosette Leaf 12",
            "id": "Rosette_Leaf_12",
            "samples": [
              "ATGE_17_A",
              "ATGE_17_B",
              "ATGE_17_C"
            ]
          },
          {
            "name": "Senescing Leaf",
            "id": "Senescing_Leaf",
            "samples": [
              "ATGE_25_A",
              "ATGE_25_B",
              "ATGE_25_C"
            ]
          },
          {
            "name": "Shoot Apex, Inflorescence",
            "id": "Shoot_Apex_Inflorescence",
            "samples": [
              "ATGE_29_A2",
              "ATGE_29_B2",
              "ATGE_29_C2"
            ]
          },
          {
            "name": "Shoot Apex, Transition",
            "id": "Shoot_Apex_Transition",
            "samples": [
              "ATGE_8_A",
              "ATGE_8_B",
              "ATGE_8_C"
            ]
          },
          {
            "name": "Shoot Apex, Vegetative",
            "id": "Shoot_Apex_Vegetative",
            "samples": [
              "ATGE_6_A",
              "ATGE_6_B",
              "ATGE_6_C"
            ]
          },
          {
            "name": "Stem, 2nd Internode",
            "id": "Stem_2nd_Internode",
            "samples": [
              "ATGE_27_A",
              "ATGE_27_B",
              "ATGE_27_C"
            ]
          },
          {
            "name": "Mature Pollen",
            "id": "Mature_Pollen",
            "samples": [
              "ATGE_73_A",
              "ATGE_73_B",
              "ATGE_73_C"
            ]
          },
          {
            "name": "Seeds Stage 3 w/ Siliques",
            "id": "Seeds_Stage_3_w_Siliques",
            "samples": [
              "ATGE_76_A",
              "ATGE_76_B",
              "ATGE_76_C"
            ]
          },
          {
            "name": "Seeds Stage 4 w/ Siliques",
            "id": "Seeds_Stage_4_w_Siliques",
            "samples": [
              "ATGE_77_D",
              "ATGE_77_E",
              "ATGE_77_F"
            ]
          },
          {
            "name": "Seeds Stage 5 w/ Siliques",
            "id": "Seeds_Stage_5_w_Siliques",
            "samples": [
              "ATGE_78_D",
              "ATGE_78_E",
              "ATGE_78_F"
            ]
          },
          {
            "name": "Seeds Stage 6 w/o Siliques",
            "id": "Seeds_Stage_6_wo_Siliques",
            "samples": [
              "ATGE_79_A",
              "ATGE_79_B",
              "ATGE_79_C"
            ]
          },
          {
            "name": "Seeds Stage 7 w/o Siliques",
            "id": "Seeds_Stage_7_wo_Siliques",
            "samples": [
              "ATGE_81_A",
              "ATGE_81_B",
              "ATGE_81_C"
            ]
          },
          {
            "name": "Seeds Stage 8 w/o Siliques",
            "id": "Seeds_Stage_8_wo_Siliques",
            "samples": [
              "ATGE_82_A",
              "ATGE_82_B",
              "ATGE_82_C"
            ]
          },
          {
            "name": "Seeds Stage 9 w/o Siliques",
            "id": "Seeds_Stage_9_wo_Siliques",
            "samples": [
              "ATGE_83_A",
              "ATGE_83_B",
              "ATGE_83_C"
            ]
          },
          {
            "name": "Seeds Stage 10 w/o Siliques",
            "id": "Seeds_Stage_10_wo_Siliques",
            "samples": [
              "ATGE_84_A",
              "ATGE_84_B",
              "ATGE_84_D"
            ]
          },
          {
            "name": "Vegetative Rosette",
            "id": "Vegetative_Rosette",
            "samples": [
              "ATGE_89_A",
              "ATGE_89_B",
              "ATGE_89_C"
            ]
          }
        ]
      }
    ]
  },
  "klepikova": {
    "db": "klepikova",
    "groups": [
      {
        "name": "Developmental Transcriptome",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Seedling Hypocotyl",
            "id": "S_H",
            "samples": [
              "SRR3581336",
              "SRR3581740"
            ]
          },
          {
            "name": "Seedling Meristem",
            "id": "S_M",
            "samples": [
              "SRR3581346",
              "SRR3581831"
            ]
          },
          {
            "name": "Seedling Cotyledons",
            "id": "S_C",
            "samples": [
              "SRR3581345",
              "SRR3581833"
            ]
          },
          {
            "name": "Seedling Root",
            "id": "S_R",
            "samples": [
              "SRR3581347",
              "SRR3581834"
            ]
          },
          {
            "name": "Leaf Petiole of the young leaf",
            "id": "L_PET_y",
            "samples": [
              "SRR3581383",
              "SRR3581837"
            ]
          },
          {
            "name": "Leaf Lamina of the young leaf",
            "id": "L_LAM_y",
            "samples": [
              "SRR3581388",
              "SRR3581838"
            ]
          },
          {
            "name": "Leaf Petiole, intermediate 1",
            "id": "L_PET_i1",
            "samples": [
              "SRR3581499",
              "SRR3581839"
            ]
          },
          {
            "name": "Leaf Lamina, intermediate 1",
            "id": "L_LAM_i1",
            "samples": [
              "SRR3581591",
              "SRR3581840"
            ]
          },
          {
            "name": "Leaf Petiole, intermediate 2",
            "id": "L_PET_i2",
            "samples": [
              "SRR3581639",
              "SRR3581841"
            ]
          },
          {
            "name": "Leaf Vein, intermediate 2",
            "id": "L_VN_i2",
            "samples": [
              "SRR3581672",
              "SRR3581842"
            ]
          },
          {
            "name": "Leaf Lamina, intermediate 2",
            "id": "L_LAM_i2",
            "samples": [
              "SRR3581676",
              "SRR3581843"
            ]
          },
          {
            "name": "Leaf, mature",
            "id": "L_lg",
            "samples": [
              "SRR3581681",
              "SRR3581847"
            ]
          },
          {
            "name": "Leaf Petiole of the mature leaf",
            "id": "L_PET_lg",
            "samples": [
              "SRR3581678",
              "SRR3581844"
            ]
          },
          {
            "name": "Leaf Vein of the mature leaf",
            "id": "L_VN_lg",
            "samples": [
              "SRR3581679",
              "SRR3581845"
            ]
          },
          {
            "name": "Leaf Lamina of the mature leaf",
            "id": "L_LAM_lg",
            "samples": [
              "SRR3581680",
              "SRR3581846"
            ]
          },
          {
            "name": "Leaf Petiole of the senescent leaf",
            "id": "L_PET_sn",
            "samples": [
              "SRR3581682",
              "SRR3581848"
            ]
          },
          {
            "name": "Leaf Vein of the senescent leaf",
            "id": "L_VN_sn",
            "samples": [
              "SRR3581683",
              "SRR3581849"
            ]
          },
          {
            "name": "Flower 1",
            "id": "F1",
            "samples": [
              "SRR3581693",
              "SRR3581859"
            ]
          },
          {
            "name": "Flower 2",
            "id": "F2",
            "samples": [
              "SRR3581694",
              "SRR3581860"
            ]
          },
          {
            "name": "Flower 3",
            "id": "F3",
            "samples": [
              "SRR3581695",
              "SRR3581861"
            ]
          },
          {
            "name": "Flower 4",
            "id": "F4",
            "samples": [
              "SRR3581696",
              "SRR3581862"
            ]
          },
          {
            "name": "Flower 5",
            "id": "F5",
            "samples": [
              "SRR3581697",
              "SRR3581863"
            ]
          },
          {
            "name": "Flowers 6-8",
            "id": "F6-8",
            "samples": [
              "SRR3581698",
              "SRR3581864"
            ]
          },
          {
            "name": "Flowers 9-11",
            "id": "F9-11",
            "samples": [
              "SRR3581699",
              "SRR3581865"
            ]
          },
          {
            "name": "Flowers 12-14",
            "id": "F12-14",
            "samples": [
              "SRR3581700",
              "SRR3581866"
            ]
          },
          {
            "name": "Flowers 15-18",
            "id": "F15-18",
            "samples": [
              "SRR3581701",
              "SRR3581867"
            ]
          },
          {
            "name": "Flowers 19 and following",
            "id": "F19",
            "samples": [
              "SRR3581702",
              "SRR3581868"
            ]
          },
          {
            "name": "Opened anthers",
            "id": "F_AN",
            "samples": [
              "SRR3581684",
              "SRR3581850"
            ]
          },
          {
            "name": "Carpels of the mature flower (before pollination)",
            "id": "F_CA_ad",
            "samples": [
              "SRR3581685",
              "SRR3581851"
            ]
          },
          {
            "name": "Anthers of the mature flower (before opening)",
            "id": "F_AN_ad",
            "samples": [
              "SRR3581852",
              "SRR3581686"
            ]
          },
          {
            "name": "Stamen filaments of the mature flower",
            "id": "F_FM_ad",
            "samples": [
              "SRR3581687",
              "SRR3581853"
            ]
          },
          {
            "name": "Petals of the mature flower",
            "id": "F_PT_ad",
            "samples": [
              "SRR3581688",
              "SRR3581854"
            ]
          },
          {
            "name": "Sepals of the mature flower",
            "id": "F_SP_ad",
            "samples": [
              "SRR3581689",
              "SRR3581855"
            ]
          },
          {
            "name": "Carpels of the young flower",
            "id": "F_CA_y",
            "samples": [
              "SRR3581690",
              "SRR3581856"
            ]
          },
          {
            "name": "Anthers of the young flower",
            "id": "F_AN_y",
            "samples": [
              "SRR3581691",
              "SRR3581857"
            ]
          },
          {
            "name": "Sepals of the young flower",
            "id": "F_SP_y",
            "samples": [
              "SRR3581692",
              "SRR3581858"
            ]
          },
          {
            "name": "Stigmatic tissue",
            "id": "STI",
            "samples": [
              "SRR3581728",
              "SRR3581890"
            ]
          },
          {
            "name": "Carpel of the 6th and 7th flowers",
            "id": "POD_y6-7",
            "samples": [
              "SRR3581730",
              "SRR3581891"
            ]
          },
          {
            "name": "Ovules from the 6th and 7th flowers",
            "id": "OV_y6-7",
            "samples": [
              "SRR3581727",
              "SRR3581889"
            ]
          },
          {
            "name": "Pedicel",
            "id": "PED",
            "samples": [
              "SRR3581703",
              "SRR3581869"
            ]
          },
          {
            "name": "Axis of influorescence",
            "id": "Ax",
            "samples": [
              "SRR3581704",
              "SRR3581870"
            ]
          },
          {
            "name": "Internode",
            "id": "IN",
            "samples": [
              "SRR3581705",
              "SRR3581871"
            ]
          },
          {
            "name": "Root Apex",
            "id": "R_A",
            "samples": [
              "SRR3581352",
              "SRR3581835"
            ]
          },
          {
            "name": "Root",
            "id": "R",
            "samples": [
              "SRR3581356",
              "SRR3581836"
            ]
          },
          {
            "name": "Young seeds 1",
            "id": "SD_y1",
            "samples": [
              "SRR3581719",
              "SRR3581884"
            ]
          },
          {
            "name": "Young seeds 2",
            "id": "SD_y2",
            "samples": [
              "SRR3581720",
              "SRR3581885"
            ]
          },
          {
            "name": "Young seeds 3",
            "id": "SD_y3",
            "samples": [
              "SRR3581721",
              "SRR3581886"
            ]
          },
          {
            "name": "Young seeds 4",
            "id": "SD_y4",
            "samples": [
              "SRR3581724",
              "SRR3581887"
            ]
          },
          {
            "name": "Young seeds 5",
            "id": "SD_y5",
            "samples": [
              "SRR3581726",
              "SRR3581888"
            ]
          },
          {
            "name": "Seeds 1",
            "id": "SD1",
            "samples": [
              "SRR3581706",
              "SRR3581872"
            ]
          },
          {
            "name": "Seeds 3",
            "id": "SD3",
            "samples": [
              "SRR3581709",
              "SRR3581875"
            ]
          },
          {
            "name": "Seeds 5",
            "id": "SD5",
            "samples": [
              "SRR3581712",
              "SRR3581878"
            ]
          },
          {
            "name": "Seeds 7",
            "id": "SD7",
            "samples": [
              "SRR3581715",
              "SRR3581881"
            ]
          },
          {
            "name": "Dry Seeds",
            "id": "SD_d",
            "samples": [
              "SRR3581731",
              "SRR3581892"
            ]
          },
          {
            "name": "Germinating seeds 1",
            "id": "SD_g1",
            "samples": [
              "SRR3581732",
              "SRR3581893"
            ]
          },
          {
            "name": "Germinating seeds 2",
            "id": "SD_g2",
            "samples": [
              "SRR3581733",
              "SRR3581894"
            ]
          },
          {
            "name": "Germinating seeds 3",
            "id": "SD_g3",
            "samples": [
              "SRR3581734",
              "SRR3581895"
            ]
          },
          {
            "name": "Senescent internode",
            "id": "IN_sn",
            "samples": [
              "SRR3581738",
              "SRR3581899"
            ]
          },
          {
            "name": "Seeds from the senescent silique 1",
            "id": "SD_sn1",
            "samples": [
              "SRR3581735",
              "SRR3581896"
            ]
          },
          {
            "name": "Pod of the senescent silique 1",
            "id": "POD_sn1",
            "samples": [
              "SRR3581736",
              "SRR3581897"
            ]
          },
          {
            "name": "Senescent silique 2",
            "id": "SL_sn2",
            "samples": [
              "SRR3581737",
              "SRR3581898"
            ]
          },
          {
            "name": "Pod of the silique 1",
            "id": "POD1",
            "samples": [
              "SRR3581707",
              "SRR3581873"
            ]
          },
          {
            "name": "Pod of the silique 3",
            "id": "POD3",
            "samples": [
              "SRR3581710",
              "SRR3581876"
            ]
          },
          {
            "name": "Pod of the silique 5",
            "id": "POD5",
            "samples": [
              "SRR3581713",
              "SRR3581879"
            ]
          },
          {
            "name": "Pod of the silique 7",
            "id": "POD7",
            "samples": [
              "SRR3581716",
              "SRR3581882"
            ]
          },
          {
            "name": "Silique 2",
            "id": "SL2",
            "samples": [
              "SRR3581708",
              "SRR3581874"
            ]
          },
          {
            "name": "Silique 4",
            "id": "SL4",
            "samples": [
              "SRR3581711",
              "SRR3581877"
            ]
          },
          {
            "name": "Silique 6",
            "id": "SL6",
            "samples": [
              "SRR3581714",
              "SRR3581880"
            ]
          },
          {
            "name": "Silique 8",
            "id": "SL8",
            "samples": [
              "SRR3581717",
              "SRR3581883"
            ]
          }
        ]
      }
    ]
  },
  "ChemicalView": {
    "db": "atgenexp_hormone",
    "groups": [
      {
        "name": "Gibberellic_Acid_Inhibitors_at_3_Hours",
        "controls": [
          "RIKEN-GODA1A2",
          "RIKEN-GODA1B2"
        ],
        "tissues": [
          {
            "name": "Propiconazole Treated at 3 Hours",
            "id": "Propiconazole_Treated_at_3_Hours",
            "samples": [
              "RIKEN-GODA3A2",
              "RIKEN-GODA3B2"
            ]
          },
          {
            "name": "Uniconazole Treated at 3 Hours",
            "id": "Uniconazole_Treated_at_3_Hours",
            "samples": [
              "RIKEN-GODA5A2",
              "RIKEN-GODA5B2"
            ]
          },
          {
            "name": "Paclobutrazol Treated at 3 Hours",
            "id": "Paclobutrazol_Treated_at_3_Hours",
            "samples": [
              "RIKEN-GODA11A2",
              "RIKEN-GODA11B2"
            ]
          },
          {
            "name": "Prohexadione Treated at 3 Hours",
            "id": "Prohexadione_Treated_at_3_Hours",
            "samples": [
              "RIKEN-GODA13A2",
              "RIKEN-GODA13B2"
            ]
          }
        ]
      },
      {
        "name": "Gibberellic_Acid_Inhibitors_at_12_Hours",
        "controls": [
          "RIKEN-GODA2A2",
          "RIKEN-GODA2B2"
        ],
        "tissues": [
          {
            "name": "Propiconazole Treated at 12 Hours",
            "id": "Propiconazole_Treated_at_12_Hours",
            "samples": [
              "RIKEN-GODA4A2",
              "RIKEN-GODA4B2"
            ]
          },
          {
            "name": "Uniconazole Treated at 12 Hours",
            "id": "Uniconazole_Treated_at_12_Hours",
            "samples": [
              "RIKEN-GODA6A2",
              "RIKEN-GODA6B2"
            ]
          },
          {
            "name": "Paclobutrazol Treated at 12 Hours",
            "id": "Paclobutrazol_Treated_at_12_Hours",
            "samples": [
              "RIKEN-GODA12A2",
              "RIKEN-GODA12B2"
            ]
          },
          {
            "name": "Prohexadione Treated at 12 Hours",
            "id": "Prohexadione_Treated_at_12_Hours",
            "samples": [
              "RIKEN-GODA14A2",
              "RIKEN-GODA14B2"
            ]
          }
        ]
      },
      {
        "name": "Auxin_Inhibitors",
        "controls": [
          "RIKEN-GODA1A2",
          "RIKEN-GODA1B2"
        ],
        "tissues": [
          {
            "name": "2,4,6-T Treated",
            "id": "2_4_6-T_Treated",
            "samples": [
              "RIKEN-GODA23A3",
              "RIKEN-GODA23B3"
            ]
          },
          {
            "name": "PCIB Treated",
            "id": "PCIB_Treated",
            "samples": [
              "RIKEN-GODA24A3",
              "RIKEN-GODA24B3"
            ]
          },
          {
            "name": "TIBA Treated",
            "id": "TIBA_Treated",
            "samples": [
              "RIKEN-GODA25A3",
              "RIKEN-GODA25B3"
            ]
          },
          {
            "name": "NPA Treated",
            "id": "NPA_Treated",
            "samples": [
              "RIKEN-GODA26A3",
              "RIKEN-GODA26B3"
            ]
          }
        ]
      },
      {
        "name": "Brassinosteroid_Inhibitors_at_3_Hours",
        "controls": [
          "RIKEN-GODA1A2",
          "RIKEN-GODA1B2"
        ],
        "tissues": [
          {
            "name": "10uM Brz220 Treated at 3 Hours",
            "id": "10uM_Brz220_Treated_at_3_Hours",
            "samples": [
              "RIKEN-GODA7A4",
              "RIKEN-GODA7B4"
            ]
          },
          {
            "name": "3uM Brz220 Treated at 3 Hours",
            "id": "3uM_Brz220_Treated_at_3_Hours",
            "samples": [
              "RIKEN-GODA30A4",
              "RIKEN-GODA30B4"
            ]
          }
        ]
      },
      {
        "name": "Brassinosteroid_Inhibitors_at_12_Hours",
        "controls": [
          "RIKEN-GODA2A2",
          "RIKEN-GODA2B2"
        ],
        "tissues": [
          {
            "name": "10uM Brz91 Treated at 12 Hours",
            "id": "10uM_Brz91_Treated_at_12_Hours",
            "samples": [
              "RIKEN-GODA10A4",
              "RIKEN-GODA10B4"
            ]
          }
        ]
      },
      {
        "name": "Ethylene Inhibitors",
        "controls": [
          "RIKEN-GODA1A2",
          "RIKEN-GODA1B2"
        ],
        "tissues": [
          {
            "name": "10uM AgNO3 Treated",
            "id": "10uM_AgNO3_Treated",
            "samples": [
              "RIKEN-GODA19A7",
              "RIKEN-GODA19B7"
            ]
          },
          {
            "name": "10uM AVG Treated",
            "id": "10uM_AVG_Treated",
            "samples": [
              "RIKEN-GODA20A7",
              "RIKEN-GODA20B7"
            ]
          }
        ]
      },
      {
        "name": "Cyclohexamide",
        "controls": [
          "RIKEN-GODA1A2",
          "RIKEN-GODA1B2"
        ],
        "tissues": [
          {
            "name": "10uM CHX Treated",
            "id": "10uM_CHX_Treated",
            "samples": [
              "RIKEN-GODA27A8",
              "RIKEN-GODA27B8"
            ]
          }
        ]
      },
      {
        "name": "Proteasome_Inhibitor_MG13",
        "controls": [
          "RIKEN-GODA1A2",
          "RIKEN-GODA1B2"
        ],
        "tissues": [
          {
            "name": "10uM MG132 Treated",
            "id": "10uM_MG132_Treated",
            "samples": [
              "RIKEN-GODA22A9",
              "RIKEN-GODA22B9"
            ]
          }
        ]
      },
      {
        "name": "Photosynthesis_Inhibitor_PN08_at_3_Hours",
        "controls": [
          "RIKEN-GODA1A2",
          "RIKEN-GODA1B2"
        ],
        "tissues": [
          {
            "name": "1uM PNO8 Treated at 3 Hours",
            "id": "1uM_PNO8_Treated_at_3_Hours",
            "samples": [
              "RIKEN-GODA15A5",
              "RIKEN-GODA15B5"
            ]
          },
          {
            "name": "10uM PNO8 Treated at 3 Hours",
            "id": "10uM_PNO8_Treated_at_3_Hours",
            "samples": [
              "RIKEN-GODA29A5",
              "RIKEN-GODA29B5"
            ]
          }
        ]
      },
      {
        "name": "Photosynthesis_Inhibitor_PN08_at_12_Hours",
        "controls": [
          "RIKEN-GODA2A2",
          "RIKEN-GODA2B2"
        ],
        "tissues": [
          {
            "name": "1uM PNO8 Treated at 12 Hours",
            "id": "1uM_PNO8_Treated_at_12_Hours",
            "samples": [
              "RIKEN-GODA16A5",
              "RIKEN-GODA16B5"
            ]
          }
        ]
      },
      {
        "name": "Ibuprofen_Salycylic_Acid_and_Daminozide",
        "controls": [
          "RIKEN-GODA1A2",
          "RIKEN-GODA1B2"
        ],
        "tissues": [
          {
            "name": "Ibuprofen Treated",
            "id": "Ibuprofen_Treated",
            "samples": [
              "RIKEN-GODA17AH",
              "RIKEN-GODA17BH"
            ]
          },
          {
            "name": "Salicylic Acid Treated",
            "id": "Salicylic_Acid_Treated",
            "samples": [
              "RIKEN-GODA21AH",
              "RIKEN-GODA21BH"
            ]
          },
          {
            "name": "Daminozide Treated",
            "id": "Daminozide_Treated",
            "samples": [
              "RIKEN-GODA18AH",
              "RIKEN-GODA18BH"
            ]
          }
        ]
      }
    ]
  },
  "AbioticStressView": {
    "db": "atgenexp_stress",
    "groups": [
      {
        "name": "Shoot 0 Hour",
        "controls": [
          "AtGen_6_0011",
          "AtGen_6_0012"
        ],
        "tissues": [
          {
            "name": "Control Shoot 0 Hour",
            "id": "Control_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "Cold Shoot 0 Hour",
            "id": "Cold_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "Osmotic Shoot 0 Hour",
            "id": "Osmotic_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "Salt Shoot 0 Hour",
            "id": "Salt_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "Drought Shoot 0 Hour",
            "id": "Drought_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "Genotoxic Shoot 0 Hour",
            "id": "Genotoxic_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "Oxidative Shoot 0 Hour",
            "id": "Oxidative_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "UV-B Shoot 0 Hour",
            "id": "UV-B_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "Wounding Shoot 0 Hour",
            "id": "Wounding_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          },
          {
            "name": "Heat Shoot 0 Hour",
            "id": "Heat_Shoot_0_Hour",
            "samples": [
              "AtGen_6_0011",
              "AtGen_6_0012"
            ]
          }
        ]
      },
      {
        "name": "Root 0 Hour",
        "controls": [
          "AtGen_6_0021",
          "AtGen_6_0022"
        ],
        "tissues": [
          {
            "name": "Control Root 0 Hour",
            "id": "Control_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "Cold Root 0 Hour",
            "id": "Cold_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "Osmotic Root 0 Hour",
            "id": "Osmotic_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "Salt Root 0 Hour",
            "id": "Salt_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "Drought Root 0 Hour",
            "id": "Drought_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "Genotoxic Root 0 Hour",
            "id": "Genotoxic_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "Oxidative Root 0 Hour",
            "id": "Oxidative_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "UV-B Root 0 Hour",
            "id": "UV-B_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "Wounding Root 0 Hour",
            "id": "Wounding_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          },
          {
            "name": "Heat Root 0 Hour",
            "id": "Heat_Root_0_Hour",
            "samples": [
              "AtGen_6_0021",
              "AtGen_6_0022"
            ]
          }
        ]
      },
      {
        "name": "Shoot After 15 Minutes",
        "controls": [
          "AtGen_6_0711",
          "AtGen_6_0712"
        ],
        "tissues": [
          {
            "name": "Control Shoot After 15 Minutes",
            "id": "Control_Shoot_After_15_Minutes",
            "samples": [
              "AtGen_6_0711",
              "AtGen_6_0712"
            ]
          },
          {
            "name": "Drought Shoot After 15 Minutes",
            "id": "Drought_Shoot_After_15_Minutes",
            "samples": [
              "AtGen_6_4711",
              "AtGen_6_4712"
            ]
          },
          {
            "name": "UV-B Shoot After 15 Minutes",
            "id": "UV-B_Shoot_After_15_Minutes",
            "samples": [
              "AtGen_6_7711",
              "AtGen_6_7712"
            ]
          },
          {
            "name": "Wounding Shoot After 15 Minutes",
            "id": "Wounding_Shoot_After_15_Minutes",
            "samples": [
              "AtGen_6_8715",
              "AtGen_6_8712"
            ]
          },
          {
            "name": "Heat Shoot After 15 Minutes",
            "id": "Heat_Shoot_After_15_Minutes",
            "samples": [
              "AtGen_6_9711",
              "AtGen_6_9712"
            ]
          }
        ]
      },
      {
        "name": "Root After 15 Minutes",
        "controls": [
          "AtGen_6_0721",
          "AtGen_6_0722"
        ],
        "tissues": [
          {
            "name": "Control Root After 15 Minutes",
            "id": "Control_Root_After_15_Minutes",
            "samples": [
              "AtGen_6_0721",
              "AtGen_6_0722"
            ]
          },
          {
            "name": "Drought Root After 15 Minutes",
            "id": "Drought_Root_After_15_Minutes",
            "samples": [
              "AtGen_6_4721",
              "AtGen_6_4722"
            ]
          },
          {
            "name": "UV-B Root After 15 Minutes",
            "id": "UV-B_Root_After_15_Minutes",
            "samples": [
              "AtGen_6_7721",
              "AtGen_6_7722"
            ]
          },
          {
            "name": "Wounding Root After 15 Minutes",
            "id": "Wounding_Root_After_15_Minutes",
            "samples": [
              "AtGen_6_8723",
              "AtGen_6_8724"
            ]
          },
          {
            "name": "Heat Root After 15 Minutes",
            "id": "Heat_Root_After_15_Minutes",
            "samples": [
              "AtGen_6_9721",
              "AtGen_6_9722"
            ]
          }
        ]
      },
      {
        "name": "Shoot After 30 Minutes",
        "controls": [
          "AtGen_6_0111",
          "AtGen_6_0112"
        ],
        "tissues": [
          {
            "name": "Control Shoot After 30 Minutes",
            "id": "Control_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_0111",
              "AtGen_6_0112"
            ]
          },
          {
            "name": "Cold Shoot After 30 Minutes",
            "id": "Cold_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_1111",
              "AtGen_6_1112"
            ]
          },
          {
            "name": "Osmotic Shoot After 30 Minutes",
            "id": "Osmotic_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_2111",
              "AtGen_6_2112"
            ]
          },
          {
            "name": "Salt Shoot After 30 Minutes",
            "id": "Salt_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_3111",
              "AtGen_6_3112"
            ]
          },
          {
            "name": "Drought Shoot After 30 Minutes",
            "id": "Drought_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_4111",
              "AtGen_6_4112"
            ]
          },
          {
            "name": "Genotoxic Shoot After 30 Minutes",
            "id": "Genotoxic_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_5111",
              "AtGen_6_5112"
            ]
          },
          {
            "name": "Oxidative Shoot After 30 Minutes",
            "id": "Oxidative_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_6111",
              "AtGen_6_6112"
            ]
          },
          {
            "name": "UV-B Shoot After 30 Minutes",
            "id": "UV-B_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_7111",
              "AtGen_6_7112"
            ]
          },
          {
            "name": "Wounding Shoot After 30 Minutes",
            "id": "Wounding_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_8111",
              "AtGen_6_8112"
            ]
          },
          {
            "name": "Heat Shoot After 30 Minutes",
            "id": "Heat_Shoot_After_30_Minutes",
            "samples": [
              "AtGen_6_9111",
              "AtGen_6_9112"
            ]
          }
        ]
      },
      {
        "name": "Root After 30 Minutes",
        "controls": [
          "AtGen_6_0121",
          "AtGen_6_0122"
        ],
        "tissues": [
          {
            "name": "Control Root After 30 Minutes",
            "id": "Control_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_0121",
              "AtGen_6_0122"
            ]
          },
          {
            "name": "Cold Root After 30 Minutes",
            "id": "Cold_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_1121",
              "AtGen_6_1122"
            ]
          },
          {
            "name": "Osmotic Root After 30 Minutes",
            "id": "Osmotic_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_2121",
              "AtGen_6_2122"
            ]
          },
          {
            "name": "Salt Root After 30 Minutes",
            "id": "Salt_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_3121",
              "AtGen_6_3122"
            ]
          },
          {
            "name": "Drought Root After 30 Minutes",
            "id": "Drought_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_4121",
              "AtGen_6_4122"
            ]
          },
          {
            "name": "Genotoxic Root After 30 Minutes",
            "id": "Genotoxic_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_5121",
              "AtGen_6_5122"
            ]
          },
          {
            "name": "Oxidative Root After 30 Minutes",
            "id": "Oxidative_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_6122",
              "AtGen_6_6124"
            ]
          },
          {
            "name": "UV-B Root After 30 Minutes",
            "id": "UV-B_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_7121",
              "AtGen_6_7122"
            ]
          },
          {
            "name": "Wounding Root After 30 Minutes",
            "id": "Wounding_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_8124",
              "AtGen_6_8126"
            ]
          },
          {
            "name": "Heat Root After 30 Minutes",
            "id": "Heat_Root_After_30_Minutes",
            "samples": [
              "AtGen_6_9121",
              "AtGen_6_9122"
            ]
          }
        ]
      },
      {
        "name": "Shoot After 1 Hour",
        "controls": [
          "AtGen_6_0211",
          "AtGen_6_0212"
        ],
        "tissues": [
          {
            "name": "Control Shoot After 1 Hour",
            "id": "Control_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_0211",
              "AtGen_6_0212"
            ]
          },
          {
            "name": "Cold Shoot After 1 Hour",
            "id": "Cold_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_1211",
              "AtGen_6_1212"
            ]
          },
          {
            "name": "Osmotic Shoot After 1 Hour",
            "id": "Osmotic_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_2211",
              "AtGen_6_2212"
            ]
          },
          {
            "name": "Salt Shoot After 1 Hour",
            "id": "Salt_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_3211",
              "AtGen_6_3212"
            ]
          },
          {
            "name": "Drought Shoot After 1 Hour",
            "id": "Drought_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_4211",
              "AtGen_6_4212"
            ]
          },
          {
            "name": "Genotoxic Shoot After 1 Hour",
            "id": "Genotoxic_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_5211",
              "AtGen_6_5212"
            ]
          },
          {
            "name": "Oxidative Shoot After 1 Hour",
            "id": "Oxidative_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_6211",
              "AtGen_6_6212"
            ]
          },
          {
            "name": "UV-B Shoot After 1 Hour",
            "id": "UV-B_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_7211",
              "AtGen_6_7212"
            ]
          },
          {
            "name": "Wounding Shoot After 1 Hour",
            "id": "Wounding_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_8211",
              "AtGen_6_8214"
            ]
          },
          {
            "name": "Heat Shoot After 1 Hour",
            "id": "Heat_Shoot_After_1_Hour",
            "samples": [
              "AtGen_6_9211",
              "AtGen_6_9212"
            ]
          }
        ]
      },
      {
        "name": "Root After 1 Hour",
        "controls": [
          "AtGen_6_0221",
          "AtGen_6_0222"
        ],
        "tissues": [
          {
            "name": "Control Root After 1 Hour",
            "id": "Control_Root_After_1_Hour",
            "samples": [
              "AtGen_6_0221",
              "AtGen_6_0222"
            ]
          },
          {
            "name": "Cold Root After 1 Hour",
            "id": "Cold_Root_After_1_Hour",
            "samples": [
              "AtGen_6_1221",
              "AtGen_6_1222"
            ]
          },
          {
            "name": "Osmotic Root After 1 Hour",
            "id": "Osmotic_Root_After_1_Hour",
            "samples": [
              "AtGen_6_2221",
              "AtGen_6_2222"
            ]
          },
          {
            "name": "Salt Root After 1 Hour",
            "id": "Salt_Root_After_1_Hour",
            "samples": [
              "AtGen_6_3221",
              "AtGen_6_3222"
            ]
          },
          {
            "name": "Drought Root After 1 Hour",
            "id": "Drought_Root_After_1_Hour",
            "samples": [
              "AtGen_6_4221",
              "AtGen_6_4222"
            ]
          },
          {
            "name": "Genotoxic Root After 1 Hour",
            "id": "Genotoxic_Root_After_1_Hour",
            "samples": [
              "AtGen_6_5221",
              "AtGen_6_5222"
            ]
          },
          {
            "name": "Oxidative Root After 1 Hour",
            "id": "Oxidative_Root_After_1_Hour",
            "samples": [
              "AtGen_6_6223",
              "AtGen_6_6224"
            ]
          },
          {
            "name": "UV-B Root After 1 Hour",
            "id": "UV-B_Root_After_1_Hour",
            "samples": [
              "AtGen_6_7221",
              "AtGen_6_7222"
            ]
          },
          {
            "name": "Wounding Root After 1 Hour",
            "id": "Wounding_Root_After_1_Hour",
            "samples": [
              "AtGen_6_8224",
              "AtGen_6_8225"
            ]
          },
          {
            "name": "Heat Root After 1 Hour",
            "id": "Heat_Root_After_1_Hour",
            "samples": [
              "AtGen_6_9221",
              "AtGen_6_9222"
            ]
          }
        ]
      },
      {
        "name": "Shoot After 3 Hours",
        "controls": [
          "AtGen_6_0311",
          "AtGen_6_0312"
        ],
        "tissues": [
          {
            "name": "Control Shoot After 3 Hours",
            "id": "Control_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_0311",
              "AtGen_6_0312"
            ]
          },
          {
            "name": "Cold Shoot After 3 Hours",
            "id": "Cold_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_1311",
              "AtGen_6_1312"
            ]
          },
          {
            "name": "Osmotic Shoot After 3 Hours",
            "id": "Osmotic_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_2311",
              "AtGen_6_2312"
            ]
          },
          {
            "name": "Salt Shoot After 3 Hours",
            "id": "Salt_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_3311",
              "AtGen_6_3312"
            ]
          },
          {
            "name": "Drought Shoot After 3 Hours",
            "id": "Drought_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_4311",
              "AtGen_6_4312"
            ]
          },
          {
            "name": "Genotoxic Shoot After 3 Hours",
            "id": "Genotoxic_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_5311",
              "AtGen_6_5312"
            ]
          },
          {
            "name": "Oxidative Shoot After 3 Hours",
            "id": "Oxidative_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_6311",
              "AtGen_6_6312"
            ]
          },
          {
            "name": "UV-B Shoot After 3 Hours",
            "id": "UV-B_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_7311",
              "AtGen_6_7312"
            ]
          },
          {
            "name": "Wounding Shoot After 3 Hours",
            "id": "Wounding_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_8313",
              "AtGen_6_8314"
            ]
          },
          {
            "name": "Heat Shoot After 3 Hours",
            "id": "Heat_Shoot_After_3_Hours",
            "samples": [
              "AtGen_6_9311",
              "AtGen_6_9312"
            ]
          }
        ]
      },
      {
        "name": "Root After 3 Hours",
        "controls": [
          "AtGen_6_0321",
          "AtGen_6_0322"
        ],
        "tissues": [
          {
            "name": "Control Root After 3 Hours",
            "id": "Control_Root_After_3_Hours",
            "samples": [
              "AtGen_6_0321",
              "AtGen_6_0322"
            ]
          },
          {
            "name": "Cold Root After 3 Hours",
            "id": "Cold_Root_After_3_Hours",
            "samples": [
              "AtGen_6_1321",
              "AtGen_6_1322"
            ]
          },
          {
            "name": "Osmotic Root After 3 Hours",
            "id": "Osmotic_Root_After_3_Hours",
            "samples": [
              "AtGen_6_2321",
              "AtGen_6_2322"
            ]
          },
          {
            "name": "Salt Root After 3 Hours",
            "id": "Salt_Root_After_3_Hours",
            "samples": [
              "AtGen_6_3321",
              "AtGen_6_3322"
            ]
          },
          {
            "name": "Drought Root After 3 Hours",
            "id": "Drought_Root_After_3_Hours",
            "samples": [
              "AtGen_6_4321",
              "AtGen_6_4322"
            ]
          },
          {
            "name": "Genotoxic Root After 3 Hours",
            "id": "Genotoxic_Root_After_3_Hours",
            "samples": [
              "AtGen_6_5321",
              "AtGen_6_5322"
            ]
          },
          {
            "name": "Oxidative Root After 3 Hours",
            "id": "Oxidative_Root_After_3_Hours",
            "samples": [
              "AtGen_6_6322",
              "AtGen_6_6323"
            ]
          },
          {
            "name": "UV-B Root After 3 Hours",
            "id": "UV-B_Root_After_3_Hours",
            "samples": [
              "AtGen_6_7321",
              "AtGen_6_7322"
            ]
          },
          {
            "name": "Wounding Root After 3 Hours",
            "id": "Wounding_Root_After_3_Hours",
            "samples": [
              "AtGen_6_8324",
              "AtGen_6_8325"
            ]
          },
          {
            "name": "Heat Root After 3 Hours",
            "id": "Heat_Root_After_3_Hours",
            "samples": [
              "AtGen_6_9321",
              "AtGen_6_9322"
            ]
          }
        ]
      },
      {
        "name": "Shoot After 4 Hours",
        "controls": [
          "AtGen_6_0811",
          "AtGen_6_0812"
        ],
        "tissues": [
          {
            "name": "Control Shoot After 4 Hours",
            "id": "Control_Shoot_After_4_Hours",
            "samples": [
              "AtGen_6_0811",
              "AtGen_6_0812"
            ]
          },
          {
            "name": "Heat Shoot After 4 Hours",
            "id": "Heat_Shoot_After_4_Hours",
            "samples": [
              "AtGen_6_9811",
              "AtGen_6_9812"
            ]
          }
        ]
      },
      {
        "name": "Root After 4 Hours",
        "controls": [
          "AtGen_6_0821",
          "AtGen_6_0822"
        ],
        "tissues": [
          {
            "name": "Control Root After 4 Hours",
            "id": "Control_Root_After_4_Hours",
            "samples": [
              "AtGen_6_0821",
              "AtGen_6_0822"
            ]
          },
          {
            "name": "Heat Root After 4 Hours",
            "id": "Heat_Root_After_4_Hours",
            "samples": [
              "AtGen_6_9821",
              "AtGen_6_9822"
            ]
          }
        ]
      },
      {
        "name": "Shoot After 6 Hours",
        "controls": [
          "AtGen_6_0411",
          "AtGen_6_0412"
        ],
        "tissues": [
          {
            "name": "Control Shoot After 6 Hours",
            "id": "Control_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_0411",
              "AtGen_6_0412"
            ]
          },
          {
            "name": "Cold Shoot After 6 Hours",
            "id": "Cold_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_1411",
              "AtGen_6_1412"
            ]
          },
          {
            "name": "Osmotic Shoot After 6 Hours",
            "id": "Osmotic_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_2411",
              "AtGen_6_2412"
            ]
          },
          {
            "name": "Salt Shoot After 6 Hours",
            "id": "Salt_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_3411",
              "AtGen_6_3412"
            ]
          },
          {
            "name": "Drought Shoot After 6 Hours",
            "id": "Drought_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_4411",
              "AtGen_6_4412"
            ]
          },
          {
            "name": "Genotoxic Shoot After 6 Hours",
            "id": "Genotoxic_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_5411",
              "AtGen_6_5412"
            ]
          },
          {
            "name": "Oxidative Shoot After 6 Hours",
            "id": "Oxidative_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_6411",
              "AtGen_6_6412"
            ]
          },
          {
            "name": "UV-B Shoot After 6 Hours",
            "id": "UV-B_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_7411",
              "AtGen_6_7412"
            ]
          },
          {
            "name": "Wounding Shoot After 6 Hours",
            "id": "Wounding_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_8411",
              "AtGen_6_8412"
            ]
          },
          {
            "name": "Heat Shoot After 6 Hours",
            "id": "Heat_Shoot_After_6_Hours",
            "samples": [
              "AtGen_6_9411",
              "AtGen_6_9412"
            ]
          }
        ]
      },
      {
        "name": "Root After 6 Hours",
        "controls": [
          "AtGen_6_0421",
          "AtGen_6_0422"
        ],
        "tissues": [
          {
            "name": "Control Root After 6 Hours",
            "id": "Control_Root_After_6_Hours",
            "samples": [
              "AtGen_6_0421",
              "AtGen_6_0422"
            ]
          },
          {
            "name": "Cold Root After 6 Hours",
            "id": "Cold_Root_After_6_Hours",
            "samples": [
              "AtGen_6_1421",
              "AtGen_6_1422"
            ]
          },
          {
            "name": "Osmotic Root After 6 Hours",
            "id": "Osmotic_Root_After_6_Hours",
            "samples": [
              "AtGen_6_2421",
              "AtGen_6_2422"
            ]
          },
          {
            "name": "Salt Root After 6 Hours",
            "id": "Salt_Root_After_6_Hours",
            "samples": [
              "AtGen_6_3421",
              "AtGen_6_3422"
            ]
          },
          {
            "name": "Drought Root After 6 Hours",
            "id": "Drought_Root_After_6_Hours",
            "samples": [
              "AtGen_6_4421",
              "AtGen_6_4422"
            ]
          },
          {
            "name": "Genotoxic Root After 6 Hours",
            "id": "Genotoxic_Root_After_6_Hours",
            "samples": [
              "AtGen_6_5421",
              "AtGen_6_5422"
            ]
          },
          {
            "name": "Oxidative Root After 6 Hours",
            "id": "Oxidative_Root_After_6_Hours",
            "samples": [
              "AtGen_6_6421",
              "AtGen_6_6422"
            ]
          },
          {
            "name": "UV-B Root After 6 Hours",
            "id": "UV-B_Root_After_6_Hours",
            "samples": [
              "AtGen_6_7421",
              "AtGen_6_7422"
            ]
          },
          {
            "name": "Wounding Root After 6 Hours",
            "id": "Wounding_Root_After_6_Hours",
            "samples": [
              "AtGen_6_8423",
              "AtGen_6_8424"
            ]
          },
          {
            "name": "Heat Root After 6 Hours",
            "id": "Heat_Root_After_6_Hours",
            "samples": [
              "AtGen_6_9421",
              "AtGen_6_9422"
            ]
          }
        ]
      },
      {
        "name": "Shoot After 12 Hours",
        "controls": [
          "AtGen_6_0511",
          "AtGen_6_0512"
        ],
        "tissues": [
          {
            "name": "Control Shoot After 12 Hours",
            "id": "Control_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_0511",
              "AtGen_6_0512"
            ]
          },
          {
            "name": "Cold Shoot After 12 Hours",
            "id": "Cold_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_1511",
              "AtGen_6_1512"
            ]
          },
          {
            "name": "Osmotic Shoot After 12 Hours",
            "id": "Osmotic_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_2511",
              "AtGen_6_2512"
            ]
          },
          {
            "name": "Salt Shoot After 12 Hours",
            "id": "Salt_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_3511",
              "AtGen_6_3512"
            ]
          },
          {
            "name": "Drought Shoot After 12 Hours",
            "id": "Drought_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_4511",
              "AtGen_6_4512"
            ]
          },
          {
            "name": "Genotoxic Shoot After 12 Hours",
            "id": "Genotoxic_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_5511",
              "AtGen_6_5512"
            ]
          },
          {
            "name": "Oxidative Shoot After 12 Hours",
            "id": "Oxidative_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_6511",
              "AtGen_6_6512"
            ]
          },
          {
            "name": "UV-B Shoot After 12 Hours",
            "id": "UV-B_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_7511",
              "AtGen_6_7512"
            ]
          },
          {
            "name": "Wounding Shoot After 12 Hours",
            "id": "Wounding_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_8511",
              "AtGen_6_8512"
            ]
          },
          {
            "name": "Heat Shoot After 12 Hours",
            "id": "Heat_Shoot_After_12_Hours",
            "samples": [
              "AtGen_6_9511",
              "AtGen_6_9512"
            ]
          }
        ]
      },
      {
        "name": "Root After 12 Hours",
        "controls": [
          "AtGen_6_0521",
          "AtGen_6_0522"
        ],
        "tissues": [
          {
            "name": "Control Root After 12 Hours",
            "id": "Control_Root_After_12_Hours",
            "samples": [
              "AtGen_6_0521",
              "AtGen_6_0522"
            ]
          },
          {
            "name": "Cold Root After 12 Hours",
            "id": "Cold_Root_After_12_Hours",
            "samples": [
              "AtGen_6_1521",
              "AtGen_6_1522"
            ]
          },
          {
            "name": "Osmotic Root After 12 Hours",
            "id": "Osmotic_Root_After_12_Hours",
            "samples": [
              "AtGen_6_2521",
              "AtGen_6_2522"
            ]
          },
          {
            "name": "Salt Root After 12 Hours",
            "id": "Salt_Root_After_12_Hours",
            "samples": [
              "AtGen_6_3521",
              "AtGen_6_3522"
            ]
          },
          {
            "name": "Drought Root After 12 Hours",
            "id": "Drought_Root_After_12_Hours",
            "samples": [
              "AtGen_6_4521",
              "AtGen_6_4522"
            ]
          },
          {
            "name": "Genotoxic Root After 12 Hours",
            "id": "Genotoxic_Root_After_12_Hours",
            "samples": [
              "AtGen_6_5521",
              "AtGen_6_5522"
            ]
          },
          {
            "name": "Oxidative Root After 12 Hours",
            "id": "Oxidative_Root_After_12_Hours",
            "samples": [
              "AtGen_6_6523",
              "AtGen_6_6524"
            ]
          },
          {
            "name": "UV-B Root After 12 Hours",
            "id": "UV-B_Root_After_12_Hours",
            "samples": [
              "AtGen_6_7521",
              "AtGen_6_7522"
            ]
          },
          {
            "name": "Wounding Root After 12 Hours",
            "id": "Wounding_Root_After_12_Hours",
            "samples": [
              "AtGen_6_8524",
              "AtGen_6_8525"
            ]
          },
          {
            "name": "Heat Root After 12 Hours",
            "id": "Heat_Root_After_12_Hours",
            "samples": [
              "AtGen_6_9521",
              "AtGen_6_9522"
            ]
          }
        ]
      },
      {
        "name": "Shoot After 24 Hours",
        "controls": [
          "AtGen_6_0611",
          "AtGen_6_0612"
        ],
        "tissues": [
          {
            "name": "Control Shoot After 24 Hours",
            "id": "Control_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_0611",
              "AtGen_6_0612"
            ]
          },
          {
            "name": "Cold Shoot After 24 Hours",
            "id": "Cold_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_1611",
              "AtGen_6_1612"
            ]
          },
          {
            "name": "Osmotic Shoot After 24 Hours",
            "id": "Osmotic_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_2611",
              "AtGen_6_2612"
            ]
          },
          {
            "name": "Salt Shoot After 24 Hours",
            "id": "Salt_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_3611",
              "AtGen_6_3612"
            ]
          },
          {
            "name": "Drought Shoot After 24 Hours",
            "id": "Drought_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_4611",
              "AtGen_6_4612"
            ]
          },
          {
            "name": "Genotoxic Shoot After 24 Hours",
            "id": "Genotoxic_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_5611",
              "AtGen_6_5612"
            ]
          },
          {
            "name": "Oxidative Shoot After 24 Hours",
            "id": "Oxidative_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_6611",
              "AtGen_6_6612"
            ]
          },
          {
            "name": "UV-B Shoot After 24 Hours",
            "id": "UV-B_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_7611",
              "AtGen_6_7612"
            ]
          },
          {
            "name": "Wounding Shoot After 24 Hours",
            "id": "Wounding_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_8611",
              "AtGen_6_8612"
            ]
          },
          {
            "name": "Heat Shoot After 24 Hours",
            "id": "Heat_Shoot_After_24_Hours",
            "samples": [
              "AtGen_6_9611",
              "AtGen_6_9612"
            ]
          }
        ]
      },
      {
        "name": "Root After 24 Hours",
        "controls": [
          "AtGen_6_0621",
          "AtGen_6_0622"
        ],
        "tissues": [
          {
            "name": "Control Root After 24 Hours",
            "id": "Control_Root_After_24_Hours",
            "samples": [
              "AtGen_6_0621",
              "AtGen_6_0622"
            ]
          },
          {
            "name": "Cold Root After 24 Hours",
            "id": "Cold_Root_After_24_Hours",
            "samples": [
              "AtGen_6_1621",
              "AtGen_6_1622"
            ]
          },
          {
            "name": "Osmotic Root After 24 Hours",
            "id": "Osmotic_Root_After_24_Hours",
            "samples": [
              "AtGen_6_2621",
              "AtGen_6_2622"
            ]
          },
          {
            "name": "Salt Root After 24 Hours",
            "id": "Salt_Root_After_24_Hours",
            "samples": [
              "AtGen_6_3621",
              "AtGen_6_3622"
            ]
          },
          {
            "name": "Drought Root After 24 Hours",
            "id": "Drought_Root_After_24_Hours",
            "samples": [
              "AtGen_6_4621",
              "AtGen_6_4622"
            ]
          },
          {
            "name": "Genotoxic Root After 24 Hours",
            "id": "Genotoxic_Root_After_24_Hours",
            "samples": [
              "AtGen_6_5621",
              "AtGen_6_5622"
            ]
          },
          {
            "name": "Oxidative Root After 24 Hours",
            "id": "Oxidative_Root_After_24_Hours",
            "samples": [
              "AtGen_6_6621",
              "AtGen_6_6625"
            ]
          },
          {
            "name": "UV-B Root After 24 Hours",
            "id": "UV-B_Root_After_24_Hours",
            "samples": [
              "AtGen_6_7621",
              "AtGen_6_7622"
            ]
          },
          {
            "name": "Wounding Root After 24 Hours",
            "id": "Wounding_Root_After_24_Hours",
            "samples": [
              "AtGen_6_8621",
              "AtGen_6_8622"
            ]
          },
          {
            "name": "Heat Root After 24 Hours",
            "id": "Heat_Root_After_24_Hours",
            "samples": [
              "AtGen_6_9621",
              "AtGen_6_9622"
            ]
          }
        ]
      }
    ]
  },
  "AbioticStressIIView": {
    "db": "atgenexp_stress",
    "groups": [
      {
        "name": "GSM491684;GSM491685;GSM491686",
        "controls": [
          "GSM491684",
          "GSM491685",
          "GSM491686"
        ],
        "tissues": [
          {
            "name": "Water limited (dry), Pre-dawn",
            "id": "WaterLimited-Predawn",
            "samples": [
              "GSM491687",
              "GSM491688",
              "GSM491689"
            ]
          },
          {
            "name": "Well watered, pre-dawn (control)",
            "id": "WellWatered-Predawn",
            "samples": [
              "GSM491684",
              "GSM491685",
              "GSM491686"
            ]
          }
        ]
      },
      {
        "name": "GSM491672;GSM491673;GSM491674",
        "controls": [
          "GSM491672",
          "GSM491673",
          "GSM491674"
        ],
        "tissues": [
          {
            "name": "Well watered, Late day (control)",
            "id": "WellWatered-LateDay",
            "samples": [
              "GSM491672",
              "GSM491673",
              "GSM491674"
            ]
          },
          {
            "name": "Water limited (dry), Late day",
            "id": "WaterLimited-LateDay",
            "samples": [
              "GSM491675",
              "GSM491676",
              "GSM491677"
            ]
          }
        ]
      },
      {
        "name": "GSM237280;GSM237281",
        "controls": [
          "GSM237280",
          "GSM237281"
        ],
        "tissues": [
          {
            "name": "Root, non-selenate treated (control)",
            "id": "NonSelenate-Root",
            "samples": [
              "GSM237280",
              "GSM237281"
            ]
          },
          {
            "name": "Root, Selenate treated ",
            "id": "Selenate-Root",
            "samples": [
              "GSM237282",
              "GSM237283"
            ]
          }
        ]
      },
      {
        "name": "GSM491666;GSM491667;GSM491668",
        "controls": [
          "GSM491666",
          "GSM491667",
          "GSM491668"
        ],
        "tissues": [
          {
            "name": "Water limited (dry), Midday",
            "id": "WaterLimited-Midday",
            "samples": [
              "GSM491669",
              "GSM491670",
              "GSM491671"
            ]
          },
          {
            "name": "Well watered, Midday (control)",
            "id": "WellWatered-Midday",
            "samples": [
              "GSM491666",
              "GSM491667",
              "GSM491668"
            ]
          }
        ]
      },
      {
        "name": "GSM392492;GSM392493",
        "controls": [
          "GSM392492",
          "GSM392493"
        ],
        "tissues": [
          {
            "name": "Shoot, non-selenate treated (control)",
            "id": "NonSelenate-Shoot",
            "samples": [
              "GSM392492",
              "GSM392493"
            ]
          }
        ]
      },
      {
        "name": "GSM40552",
        "controls": [
          "GSM40552"
        ],
        "tissues": [
          {
            "name": "Non Stressed (control), Total RNA",
            "id": "NonStressed-TotalRNA",
            "samples": [
              "GSM40552"
            ]
          },
          {
            "name": "Hypoxia Stress, Total RNA",
            "id": "Hypoxia-TotalRNA",
            "samples": [
              "GSM40553"
            ]
          }
        ]
      },
      {
        "name": "GSM40554",
        "controls": [
          "GSM40554"
        ],
        "tissues": [
          {
            "name": "Non Stressed (control), Polysomal RNA",
            "id": "NonStressed-PolysomalMRNA",
            "samples": [
              "GSM40554"
            ]
          },
          {
            "name": "Hypoxia Stress, Polysomal RNA",
            "id": "Hypoxia-PolysomalMRNA",
            "samples": [
              "GSM40555"
            ]
          }
        ]
      },
      {
        "name": "GSM237292;GSM237293",
        "controls": [
          "GSM237292",
          "GSM237293"
        ],
        "tissues": [
          {
            "name": "Shoot, selenate treated ",
            "id": "Selenate-Shoot",
            "samples": [
              "GSM237294",
              "GSM237295"
            ]
          }
        ]
      },
      {
        "name": "GSM491678;GSM491679;GSM491680",
        "controls": [
          "GSM491678",
          "GSM491679",
          "GSM491680"
        ],
        "tissues": [
          {
            "name": "Well watered, midnight (control)",
            "id": "WellWatered-Midnight",
            "samples": [
              "GSM491678",
              "GSM491679",
              "GSM491680"
            ]
          },
          {
            "name": "Water limited (dry), midnight",
            "id": "WaterLimited-Midnight",
            "samples": [
              "GSM491681",
              "GSM491682",
              "GSM491683"
            ]
          }
        ]
      }
    ]
  },
  "DNADamageView": {
    "db": "dna_damage",
    "groups": [
      {
        "name": "col-0_rep1_20min_minus_Y;col-0_rep2_20min_minus_Y",
        "controls": [
          "col-0_rep1_20min_minus_Y",
          "col-0_rep2_20min_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ Col-0 20min",
            "id": "wt-ir-t20",
            "samples": [
              "col-0_rep1_20min_plus_Y",
              "col-0_rep2_20min_plus_Y"
            ]
          },
          {
            "name": "Y- Col-0 20min",
            "id": "wt-ctrl-t20",
            "samples": [
              "col-0_rep1_20min_minus_Y",
              "col-0_rep2_20min_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "col-0_rep1_90min_minus_Y;col-0_rep2_90min_minus_Y",
        "controls": [
          "col-0_rep1_90min_minus_Y",
          "col-0_rep2_90min_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ Col-0 90min",
            "id": "wt-ir-t130",
            "samples": [
              "col-0_rep1_90min_plus_Y",
              "col-0_rep2_90min_plus_Y"
            ]
          },
          {
            "name": "Y- Col-0 90min",
            "id": "wt-ctrl-t130",
            "samples": [
              "col-0_rep1_90min_minus_Y",
              "col-0_rep2_90min_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "col-0_rep1_3hr_minus_Y;col-0_rep2_3hr_minus_Y",
        "controls": [
          "col-0_rep1_3hr_minus_Y",
          "col-0_rep2_3hr_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ Col-0 3h",
            "id": "wt-ir-t300",
            "samples": [
              "col-0_rep1_3hr_plus_Y",
              "col-0_rep2_3hr_plus_Y"
            ]
          },
          {
            "name": "Y- Col-0 3h",
            "id": "wt-ctrl-t300",
            "samples": [
              "col-0_rep1_3hr_minus_Y",
              "col-0_rep2_3hr_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "col-0_rep1_6hr_minus_Y;col-0_rep2_6hr_minus_Y",
        "controls": [
          "col-0_rep1_6hr_minus_Y",
          "col-0_rep2_6hr_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ Col-0 6h",
            "id": "wt-ir-t600",
            "samples": [
              "col-0_rep1_6hr_plus_Y",
              "col-0_rep2_6hr_plus_Y"
            ]
          },
          {
            "name": "Y- Col-0 6h",
            "id": "wt-ctrl-t600",
            "samples": [
              "col-0_rep1_6hr_minus_Y",
              "col-0_rep2_6hr_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "col-0_rep1_12hr_minus_Y;col-0_rep2_12hr_minus_Y",
        "controls": [
          "col-0_rep1_12hr_minus_Y",
          "col-0_rep2_12hr_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ Col-0 12h",
            "id": "wt-ir-t1200",
            "samples": [
              "col-0_rep1_12hr_plus_Y",
              "col-0_rep2_12hr_plus_Y"
            ]
          },
          {
            "name": "Y- Col-0 12h",
            "id": "wt-ctrl-t1200",
            "samples": [
              "col-0_rep1_12hr_minus_Y",
              "col-0_rep2_12hr_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "col-0_rep1_24hr_minus_Y;col-0_rep2_24hr_minus_Y",
        "controls": [
          "col-0_rep1_24hr_minus_Y",
          "col-0_rep2_24hr_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ Col-0 24h",
            "id": "wt-ir-t2400",
            "samples": [
              "col-0_rep1_24hr_plus_Y",
              "col-0_rep2_24hr_plus_Y"
            ]
          },
          {
            "name": "Y- Col-0 24h",
            "id": "wt-ctrl-t2400",
            "samples": [
              "col-0_rep1_24hr_minus_Y",
              "col-0_rep2_24hr_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "sog1-1_rep1_20min_minus_Y;sog1-1_rep2_20min_minus_Y",
        "controls": [
          "sog1-1_rep1_20min_minus_Y",
          "sog1-1_rep2_20min_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ sog1-1 20min",
            "id": "sog1-ir-t20",
            "samples": [
              "sog1-1_rep1_20min_plus_Y",
              "sog1-1_rep2_20min_plus_Y"
            ]
          },
          {
            "name": "Y- sog1-1 20min",
            "id": "sog1-ctrl-t20",
            "samples": [
              "sog1-1_rep1_20min_minus_Y",
              "sog1-1_rep2_20min_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "sog1-1_rep1_90min_minus_Y;sog1-1_rep2_90min_minus_Y",
        "controls": [
          "sog1-1_rep1_90min_minus_Y",
          "sog1-1_rep2_90min_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ sog1-1 90min",
            "id": "sog1-ir-t130",
            "samples": [
              "sog1-1_rep1_90min_plus_Y",
              "sog1-1_rep2_90min_plus_Y"
            ]
          },
          {
            "name": "Y- sog1-1 90min",
            "id": "sog1-ctrl-t130",
            "samples": [
              "sog1-1_rep1_90min_minus_Y",
              "sog1-1_rep2_90min_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "sog1-1_rep1_3hr_minus_Y;sog1-1_rep2_3hr_minus_Y",
        "controls": [
          "sog1-1_rep1_3hr_minus_Y",
          "sog1-1_rep2_3hr_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ sog1-1 3h",
            "id": "sog1-ir-t300",
            "samples": [
              "sog1-1_rep1_3hr_plus_Y",
              "sog1-1_rep2_3hr_plus_Y"
            ]
          },
          {
            "name": "Y- sog1-1 3h",
            "id": "sog1-ctrl-t300",
            "samples": [
              "sog1-1_rep1_3hr_minus_Y",
              "sog1-1_rep2_3hr_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "sog1-1_rep1_6hr_minus_Y;sog1-1_rep2_6hr_minus_Y",
        "controls": [
          "sog1-1_rep1_6hr_minus_Y",
          "sog1-1_rep2_6hr_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ sog1-1 6h",
            "id": "sog1-ir-t600",
            "samples": [
              "sog1-1_rep1_6hr_plus_Y",
              "sog1-1_rep2_6hr_plus_Y"
            ]
          },
          {
            "name": "Y- sog1-1 6h",
            "id": "sog1-ctrl-t600",
            "samples": [
              "sog1-1_rep1_6hr_minus_Y",
              "sog1-1_rep2_6hr_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "sog1-1_rep1_12hr_minus_Y;sog1-1_rep2_12hr_minus_Y",
        "controls": [
          "sog1-1_rep1_12hr_minus_Y",
          "sog1-1_rep2_12hr_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ sog1-1 12h",
            "id": "sog1-ir-t1200",
            "samples": [
              "sog1-1_rep1_12hr_plus_Y",
              "sog1-1_rep2_12hr_plus_Y"
            ]
          },
          {
            "name": "Y- sog1-1 12h",
            "id": "sog1-ctrl-t1200",
            "samples": [
              "sog1-1_rep1_12hr_minus_Y",
              "sog1-1_rep2_12hr_minus_Y"
            ]
          }
        ]
      },
      {
        "name": "sog1-1_rep1_24hr_minus_Y;sog1-1_rep2_24hr_minus_Y",
        "controls": [
          "sog1-1_rep1_24hr_minus_Y",
          "sog1-1_rep2_24hr_minus_Y"
        ],
        "tissues": [
          {
            "name": "Y+ sog1-1 24h",
            "id": "sog1-ir-t2400",
            "samples": [
              "sog1-1_rep1_24hr_plus_Y",
              "sog1-1_rep2_24hr_plus_Y"
            ]
          },
          {
            "name": "Y- sog1-1 24h",
            "id": "sog1-ctrl-t2400",
            "samples": [
              "sog1-1_rep1_24hr_minus_Y",
              "sog1-1_rep2_24hr_minus_Y"
            ]
          }
        ]
      }
    ]
  },
  "HeteroderaschachtiiView": {
    "db": "heterodera_schachtii",
    "groups": [
      {
        "name": "H48_Cont",
        "controls": [
          "48h_1",
          "48h_2",
          "48h_3"
        ],
        "tissues": [
          {
            "name": "48h_i",
            "id": "48h_i",
            "samples": [
              "48h_1_1",
              "48h_1_2",
              "48h_1_3"
            ]
          },
          {
            "name": "48h",
            "id": "48h",
            "samples": [
              "48h_1",
              "48h_2",
              "48h_3"
            ]
          }
        ]
      },
      {
        "name": "D12F_Cont",
        "controls": [
          "d12_f_c_1",
          "d12_f_c_2",
          "d12_f_c_3"
        ],
        "tissues": [
          {
            "name": "d12_f_i",
            "id": "d12_f_i",
            "samples": [
              "d12_f_i_1",
              "d12_f_i_2",
              "d12_f_i_3"
            ]
          },
          {
            "name": "d12_f_c",
            "id": "d12_f_c",
            "samples": [
              "d12_f_c_1",
              "d12_f_c_2",
              "d12_f_c_3"
            ]
          }
        ]
      },
      {
        "name": "D24F_Cont",
        "controls": [
          "d24f_c_1",
          "d24f_c_2",
          "d24f_c_3"
        ],
        "tissues": [
          {
            "name": "d24_f_i",
            "id": "d24_f_i",
            "samples": [
              "d24_f_i_1",
              "d24_f_i_2",
              "d24_f_i_3"
            ]
          },
          {
            "name": "d24_f_c",
            "id": "d24_f_c",
            "samples": [
              "d24_f_c_1",
              "d24_f_c_2",
              "d24_f_c_3"
            ]
          }
        ]
      },
      {
        "name": "D12M_Cont",
        "controls": [
          "d12m_c_1",
          "d12m_c_2",
          "d12m_c_3"
        ],
        "tissues": [
          {
            "name": "d12_m_i",
            "id": "d12_m_i",
            "samples": [
              "d12_m_i_1",
              "d12_m_i_2",
              "d12_m_i_3"
            ]
          },
          {
            "name": "d12m_c",
            "id": "d12m_c",
            "samples": [
              "d12m_c_1",
              "d12m_c_2",
              "d12m_c_3"
            ]
          }
        ]
      },
      {
        "name": "H10_Cont",
        "controls": [
          "h10c_1",
          "h10c_2",
          "h10c_1"
        ],
        "tissues": [
          {
            "name": "h10i",
            "id": "h10i",
            "samples": [
              "h10i_1",
              "h10i_2",
              "h10i_3"
            ]
          },
          {
            "name": "h10c",
            "id": "h10c",
            "samples": [
              "h10c_1",
              "h10c_2",
              "h10c_3"
            ]
          }
        ]
      }
    ]
  },
  "GuardCellDroughtView": {
    "db": "gc_drought",
    "groups": [
      {
        "name": "L60w3;L60w1;L60w2",
        "controls": [
          "L60w3",
          "L60w1",
          "L60w2"
        ],
        "tissues": [
          {
            "name": "L60d",
            "id": "L60d",
            "samples": [
              "L60d1",
              "L60d2",
              "L60d3"
            ]
          }
        ]
      },
      {
        "name": "L60w1;L60w2;L60w3",
        "controls": [
          "L60w1",
          "L60w2",
          "L60w3"
        ],
        "tissues": [
          {
            "name": "L60w",
            "id": "L60w",
            "samples": [
              "L60w1",
              "L60w2",
              "L60w3"
            ]
          }
        ]
      },
      {
        "name": "L20w1;L20w2;L20w3",
        "controls": [
          "L20w1",
          "L20w2",
          "L20w3"
        ],
        "tissues": [
          {
            "name": "L20w",
            "id": "L20w",
            "samples": [
              "L20w1",
              "L20w2",
              "L20w3"
            ]
          },
          {
            "name": "Lrw",
            "id": "Lrw",
            "samples": [
              "Lrw1",
              "Lrw2",
              "Lrw3"
            ]
          }
        ]
      },
      {
        "name": "",
        "controls": [],
        "tissues": [
          {
            "name": "svg6",
            "id": "svg6",
            "samples": []
          },
          {
            "name": "svg12",
            "id": "svg12",
            "samples": []
          },
          {
            "name": "svg13",
            "id": "svg13",
            "samples": []
          },
          {
            "name": "Text Element 0",
            "id": "Text_Element_0",
            "samples": []
          },
          {
            "name": "Text Element 1",
            "id": "Text_Element_1",
            "samples": []
          },
          {
            "name": "Text Element 2",
            "id": "Text_Element_2",
            "samples": []
          },
          {
            "name": "Text Element 3",
            "id": "Text_Element_3",
            "samples": []
          },
          {
            "name": "Text Element 4",
            "id": "Text_Element_4",
            "samples": []
          },
          {
            "name": "Text Element 5",
            "id": "Text_Element_5",
            "samples": []
          },
          {
            "name": "Unnamed Element 0",
            "id": "Unnamed_Element_0",
            "samples": []
          },
          {
            "name": "Unnamed Element 1",
            "id": "Unnamed_Element_1",
            "samples": []
          },
          {
            "name": "Text Element 6",
            "id": "Text_Element_6",
            "samples": []
          }
        ]
      },
      {
        "name": "L40w1;L40w2;L40w3",
        "controls": [
          "L40w1",
          "L40w2",
          "L40w3"
        ],
        "tissues": [
          {
            "name": "L40d",
            "id": "L40d",
            "samples": [
              "L40d1",
              "L40d2",
              "L40d3"
            ]
          },
          {
            "name": "L40w",
            "id": "L40w",
            "samples": [
              "L40w1",
              "L40w2",
              "L40w3"
            ]
          }
        ]
      },
      {
        "name": "GC60w1;GC60w2;GC60w3",
        "controls": [
          "GC60w1",
          "GC60w2",
          "GC60w3"
        ],
        "tissues": [
          {
            "name": "GC60w",
            "id": "GC60w",
            "samples": [
              "GC60w1",
              "GC60w2",
              "GC60w3"
            ]
          },
          {
            "name": "GC60d",
            "id": "GC60d",
            "samples": [
              "GC60d1",
              "GC60d2",
              "GC60d3"
            ]
          }
        ]
      },
      {
        "name": "GC40w1;GC40w2;GC40w3",
        "controls": [
          "GC40w1",
          "GC40w2",
          "GC40w3"
        ],
        "tissues": [
          {
            "name": "GC40w",
            "id": "GC40w",
            "samples": [
              "GC40w1",
              "GC40w2",
              "GC40w3"
            ]
          },
          {
            "name": "GC40d",
            "id": "GC40d",
            "samples": [
              "GC40d1",
              "GC40d2"
            ]
          }
        ]
      },
      {
        "name": "GC20w1;GC20w2;GC20w3",
        "controls": [
          "GC20w1",
          "GC20w2",
          "GC20w3"
        ],
        "tissues": [
          {
            "name": "GC20d",
            "id": "GC20d",
            "samples": [
              "GC20d1",
              "GC20d2",
              "GC20d3",
              "GC20d4"
            ]
          },
          {
            "name": "GC20w",
            "id": "GC20w",
            "samples": [
              "GC20w1",
              "GC20w2",
              "GC20w3"
            ]
          },
          {
            "name": "GCrw",
            "id": "GCrw",
            "samples": [
              "GCrw1",
              "GCrw2",
              "GCrw3"
            ]
          }
        ]
      },
      {
        "name": "L20w3;L20w2;L20w1",
        "controls": [
          "L20w3",
          "L20w2",
          "L20w1"
        ],
        "tissues": [
          {
            "name": "L20d",
            "id": "L20d",
            "samples": [
              "L20d1",
              "L20d2",
              "L20d3"
            ]
          }
        ]
      }
    ]
  },
  "GuardCellMeristemoidsView": {
    "db": "guard_cell",
    "groups": [
      {
        "name": "GSM738872_C2;GSM738873_C3;GSM738874_C4",
        "controls": [
          "GSM738872_C2",
          "GSM738873_C3",
          "GSM738874_C4"
        ],
        "tissues": [
          {
            "name": "Col-0 WT whole seedling at 5 dpg",
            "id": "Col-0_WT_whole_seedling_at_5_dpg",
            "samples": [
              "GSM738872_C2",
              "GSM738873_C3",
              "GSM738874_C4"
            ]
          },
          {
            "name": "spch whole seedling at 5 dpg",
            "id": "spch_whole_seedling_at_5_dpg",
            "samples": [
              "GSM738875_S2",
              "GSM738876_S3",
              "GSM738877_S4"
            ]
          },
          {
            "name": "scrm-D mute whole seedling at 5 dpg",
            "id": "scrm-D_mute_whole_seedling_at_5_dpg",
            "samples": [
              "GSM738878_M2",
              "GSM738879_M3",
              "GSM738880_M4"
            ]
          },
          {
            "name": "scrm-D whole seedling at 5 dpg",
            "id": "scrm-D_whole_seedling_at_5_dpg",
            "samples": [
              "GSM738881_R2",
              "GSM738882_R3",
              "GSM738883_R4"
            ]
          }
        ]
      }
    ]
  },
  "GuardCellMutantAndWildTypeGuardCellABAResponseView": {
    "db": "guard_cell",
    "groups": [
      {
        "name": "Assmann_GC_Mutants_ABA_WT",
        "controls": [
          "GSM486892",
          "GSM486893",
          "GSM486894"
        ],
        "tissues": [
          {
            "name": "WT Col-0 guard cells, no ABA",
            "id": "WT_Col-0_guard_cells_no_ABA",
            "samples": [
              "GSM486892",
              "GSM486893",
              "GSM486894"
            ]
          },
          {
            "name": "WT Col-0 guard cells, plus 50 uM ABA",
            "id": "WT_Col-0_guard_cells_plus_50_uM_ABA",
            "samples": [
              "GSM486904",
              "GSM486905",
              "GSM486906"
            ]
          }
        ]
      },
      {
        "name": "Assmann_GC_Mutants_ABA_agb1",
        "controls": [
          "GSM486895",
          "GSM486896",
          "GSM486897"
        ],
        "tissues": [
          {
            "name": "agb1 guard cells, no ABA",
            "id": "agb1_guard_cells_no_ABA",
            "samples": [
              "GSM486895",
              "GSM486896",
              "GSM486897"
            ]
          },
          {
            "name": "agb1 guard cells, plus 50 uM ABA",
            "id": "agb1_guard_cells_plus_50_uM_ABA",
            "samples": [
              "GSM486907",
              "GSM486908",
              "GSM486909"
            ]
          }
        ]
      },
      {
        "name": "Assmann_GC_Mutants_ABA_gpa1",
        "controls": [
          "GSM486898",
          "GSM486899",
          "GSM486900"
        ],
        "tissues": [
          {
            "name": "gpa1 guard cells, no ABA",
            "id": "gpa1_guard_cells_no_ABA",
            "samples": [
              "GSM486898",
              "GSM486899",
              "GSM486900"
            ]
          },
          {
            "name": "gpa1 guard cells, plus 50 uM ABA",
            "id": "gpa1_guard_cells_plus_50_uM_ABA",
            "samples": [
              "GSM486910",
              "GSM486911",
              "GSM486912"
            ]
          }
        ]
      },
      {
        "name": "Assmann_GC_Mutants_ABA_agb1-gpa1",
        "controls": [
          "GSM486901",
          "GSM486902",
          "GSM486903"
        ],
        "tissues": [
          {
            "name": "agb1 gpa1 guard cells, no ABA",
            "id": "agb1_gpa1_guard_cells_no_ABA",
            "samples": [
              "GSM486901",
              "GSM486902",
              "GSM486903"
            ]
          },
          {
            "name": "agb1 gpa1 guard cells, plus 50 uM ABA",
            "id": "agb1_gpa1_guard_cells_plus_50_uM_ABA",
            "samples": [
              "GSM486913",
              "GSM486914",
              "GSM486915"
            ]
          }
        ]
      },
      {
        "name": "Assmann_Leaf_Mutants_ABA_WT",
        "controls": [
          "GSM486916",
          "GSM486917",
          "GSM486918"
        ],
        "tissues": [
          {
            "name": "WT Col-0 leaf, no ABA",
            "id": "WT_Col-0_leaf_no_ABA",
            "samples": [
              "GSM486916",
              "GSM486917",
              "GSM486918"
            ]
          },
          {
            "name": "WT Col-0 leaf, plus 50 uM ABA",
            "id": "WT_Col-0_leaf_plus_50_uM_ABA",
            "samples": [
              "GSM486928",
              "GSM486929",
              "GSM486930"
            ]
          }
        ]
      },
      {
        "name": "Assmann_Leaf_Mutants_ABA_agb1",
        "controls": [
          "GSM486919",
          "GSM486920",
          "GSM486921"
        ],
        "tissues": [
          {
            "name": "agb1 leaf, no ABA",
            "id": "agb1_leaf_no_ABA",
            "samples": [
              "GSM486919",
              "GSM486920",
              "GSM486921"
            ]
          },
          {
            "name": "agb1 leaf, plus 50 uM ABA",
            "id": "agb1_leaf_plus_50_uM_ABA",
            "samples": [
              "GSM486931",
              "GSM486932",
              "GSM486933"
            ]
          }
        ]
      },
      {
        "name": "Assmann_Leaf_Mutants_ABA_gpa1",
        "controls": [
          "GSM486922",
          "GSM486923",
          "GSM486924"
        ],
        "tissues": [
          {
            "name": "gpa1 leaf, no ABA",
            "id": "gpa1_leaf_no_ABA",
            "samples": [
              "GSM486922",
              "GSM486923",
              "GSM486924"
            ]
          },
          {
            "name": "gpa1 leaf, plus 50 uM ABA",
            "id": "gpa1_leaf_plus_50_uM_ABA",
            "samples": [
              "GSM486934",
              "GSM486935",
              "GSM486936"
            ]
          }
        ]
      },
      {
        "name": "Assmann_Leaf_Mutants_ABA_agb1-gpa1",
        "controls": [
          "GSM486925",
          "GSM486926",
          "GSM486927"
        ],
        "tissues": [
          {
            "name": "agb1 gpa1 leaf, no ABA",
            "id": "agb1_gpa1_leaf_no_ABA",
            "samples": [
              "GSM486925",
              "GSM486926",
              "GSM486927"
            ]
          },
          {
            "name": "agb1 gpa1 leaf, plus 50 uM ABA",
            "id": "agb1_gpa1_leaf_plus_50_uM_ABA",
            "samples": [
              "GSM486937",
              "GSM486938",
              "GSM486939"
            ]
          }
        ]
      }
    ]
  },
  "GuardCellSuspensionCellABAResponseWithROSScavengerView": {
    "db": "guard_cell",
    "groups": [
      {
        "name": "Schroeder_suspension_cell_DMTU_ABA_experiments",
        "controls": [
          "GSM571891",
          "GSM571893",
          "GSM571895"
        ],
        "tissues": [
          {
            "name": "Suspension cell culture, control",
            "id": "Suspension_cell_culture_control",
            "samples": [
              "GSM571891",
              "GSM571893",
              "GSM571895"
            ]
          },
          {
            "name": "Suspension cell culture, plus 50 uM ABA",
            "id": "Suspension_cell_culture_plus_50_uM_ABA",
            "samples": [
              "GSM571892",
              "GSM571894",
              "GSM571896"
            ]
          },
          {
            "name": "Suspension cell culture, plus 5 mM DMTU",
            "id": "Suspension_cell_culture_plus_5_mM_DMTU",
            "samples": [
              "GSM604752",
              "GSM604753",
              "GSM604754"
            ]
          },
          {
            "name": "Suspension cell culture, plus 50 uM ABA and 5 mM DMTU",
            "id": "Suspension_cell_culture_plus_50_uM_ABA_and_5_mM_DMTU",
            "samples": [
              "GSM604755",
              "GSM604751",
              "GSM604750"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificGuardAndMesophyllCellsView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [],
        "tissues": [
          {
            "name": "Mesophyll cells, with 100 uM ABA",
            "id": "Mesophyll_cells_with_100_uM_ABA",
            "samples": [
              "JS88",
              "JS36"
            ]
          },
          {
            "name": "Mesophyll cells, no ABA",
            "id": "Mesophyll_cells_no_ABA",
            "samples": [
              "JS87",
              "JS35"
            ]
          },
          {
            "name": "Guard cells, no ABA",
            "id": "Guard_cells_no_ABA",
            "samples": [
              "JS85",
              "JS33"
            ]
          },
          {
            "name": "Guard cells, with 100 uM ABA",
            "id": "Guard_cells_with_100_uM_ABA",
            "samples": [
              "JS86",
              "JS34"
            ]
          },
          {
            "name": "Guard cells, no ABA, no cordycepin nor actinomycin",
            "id": "Guard_cells_no_ABA_no_cordycepin_nor_actinomycin",
            "samples": [
              "JS85"
            ]
          },
          {
            "name": "Mesophyll cells, no ABA, no cordycepin nor actinomycin",
            "id": "Mesophyll_cells_no_ABA_no_cordycepin_nor_actinomycin",
            "samples": [
              "JS87"
            ]
          },
          {
            "name": "Mesophyll cells, no ABA, cordycepin and actinomycin added during protoplasting",
            "id": "Mesophyll_cells_no_ABA_cordycepin_and_actinomycin_added_during_protoplasting",
            "samples": [
              "JS35"
            ]
          },
          {
            "name": "Mesophyll cells, with 100uM ABA, no cordycepin nor actinomycin",
            "id": "Mesophyll_cells_with_100uM_ABA_no_cordycepin_nor_actinomycin",
            "samples": [
              "JS88"
            ]
          },
          {
            "name": "Mesophyll cells with 100uM ABA, cordycepin and actinomycin added during protoplasting",
            "id": "Mesophyll_cells_with_100uM_ABA_cordycepin_and_actinomycin_added_during_protoplasting",
            "samples": [
              "JS36"
            ]
          },
          {
            "name": "Guard cells, no ABA, cordycepin and actinomycin added during protoplasting",
            "id": "Guard_cells_no_ABA_cordycepin_and_actinomycin_added_during_protoplasting",
            "samples": [
              "JS33"
            ]
          },
          {
            "name": "Guard cells, with 100uM ABA, cordycepin and actinomycin added during protoplasting",
            "id": "Guard_cells_with_100uM_ABA_cordycepin_and_actinomycin_added_during_protoplasting",
            "samples": [
              "JS34"
            ]
          },
          {
            "name": "Guard cells, with 100uM ABA, no cordycepin nor actinomycin",
            "id": "Guard_cells_with_100uM_ABA_no_cordycepin_nor_actinomycin",
            "samples": [
              "JS86"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificEmbryoDevelopmentView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [
          "ATGE_CTRL_7"
        ],
        "tissues": [
          {
            "name": "Torpedo - Basal",
            "id": "Torpedo_Basal",
            "samples": [
              "Lindsey_1-19_torpedo-basal_Rep4_ATH1",
              "Lindsey_1-20_torpedo-basal_Rep5_ATH1",
              "Lindsey_1-21_torpedo-basal_Rep6_ATH1"
            ]
          },
          {
            "name": "Torpedo - Apical",
            "id": "Torpedo_Apical",
            "samples": [
              "Lindsey_1-22_torpedo-apical_Rep4_ATH1",
              "Lindsey_1-23_torpedo-apical_Rep5_ATH1",
              "Lindsey_1-24_torpedo-apical_Rep6_ATH1"
            ]
          },
          {
            "name": "Torpedo - Cotyledon",
            "id": "Torpedo_Cotyledon",
            "samples": [
              "Lindsey_1-13_torpedo-cotyledon_Rep1_ATH1",
              "Lindsey_1-15_torpedo-cotyledon_Rep2_ATH1",
              "Lindsey_1-17_torpedo-cotyledon_Rep3_ATH1"
            ]
          },
          {
            "name": "Torpedo - Root",
            "id": "Torpedo_Root",
            "samples": [
              "Lindsey_1-14_torpedo-root_Rep1_ATH1",
              "Lindsey_1-16_torpedo-root_Rep2_ATH1",
              "Lindsey_1-18_torpedo-root_Rep3_ATH1"
            ]
          },
          {
            "name": "Torpedo - Meristem",
            "id": "Torpedo_Meristem",
            "samples": [
              "Lindsey_1-25_torpedo-meristem_Rep1_ATH1",
              "Lindsey_1-26_torpedo-meristem_Rep2_ATH1",
              "Lindsey_1-27_torpedo-meristem_Rep3_ATH1"
            ]
          },
          {
            "name": "Heart - Cotyledon",
            "id": "Heart_Cotyledon",
            "samples": [
              "Lindsey_1-7_heart-stage-cotyledon_Rep1_ATH1",
              "Lindsey_1-8_heart-stage-cotyledon_Rep2_ATH1",
              "Lindsey_1-9_heart-stage-cotyledon_Rep3_ATH1"
            ]
          },
          {
            "name": "Heart - Root",
            "id": "Heart_Root",
            "samples": [
              "Lindsey_1-10_heart-stage-root_Rep1_ATH1",
              "Lindsey_1-11_heart-stage-root_Rep2_ATH1",
              "Lindsey_1-12_heart-stage-root_Rep3_ATH1"
            ]
          },
          {
            "name": "Globular - Apical",
            "id": "Globular_Apical",
            "samples": [
              "Lindsey_1-1_globular-apical_Rep1_ATH1",
              "Lindsey_1-2_globular-apical_Rep2_ATH1",
              "Lindsey_1-3_globular-apical_Rep3_ATH1"
            ]
          },
          {
            "name": "Globular - Basal",
            "id": "Globular_Basal",
            "samples": [
              "Lindsey_1-4_globular-basal_Rep1_ATH1",
              "Lindsey_1-5_globular-basal_Rep2_ATH1",
              "Lindsey_1-6_globular-basal_Rep3_ATH1"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificMicrogametogenesisView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [
          "ATGE_CTRL_7"
        ],
        "tissues": [
          {
            "name": "Uninucleate Microphore",
            "id": "Uninucleate_Microphore",
            "samples": [
              "Honys_UNM1_SLD",
              "Honys_UNM2_SLD"
            ]
          },
          {
            "name": "Bicellular Pollen",
            "id": "Bicellular_Pollen",
            "samples": [
              "Honys_BCP1_SLD",
              "Honys_BCP2_SLD"
            ]
          },
          {
            "name": "Tricellular Pollen",
            "id": "Tricellular_Pollen",
            "samples": [
              "Honys_TCP1_SLD",
              "Honys_TCP2_SLD"
            ]
          },
          {
            "name": "Mature Pollen Grain",
            "id": "Mature_Pollen_Grain",
            "samples": [
              "Honys_MPG1_SLD"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificPollenGerminationView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [],
        "tissues": [
          {
            "name": "Pollen tubes harvested after growth through pistil explants",
            "id": "Pollen_tubes_harvested_after_growth_through_pistil_explants",
            "samples": [
              "GSM433646",
              "GSM433647",
              "GSM433648"
            ]
          },
          {
            "name": "Pollen, germinated in vitro for 4 hours",
            "id": "Pollen_germinated_in_vitro_for_4_hours",
            "samples": [
              "GSM433642",
              "GSM433643",
              "GSM433644",
              "GSM433645"
            ]
          },
          {
            "name": "Pollen, germinated in vitro for 30 minutes",
            "id": "Pollen_germinated_in_vitro_for_30_minutes",
            "samples": [
              "GSM433638",
              "GSM433639",
              "GSM433640",
              "GSM433641"
            ]
          },
          {
            "name": "Dry pollen",
            "id": "Dry_pollen",
            "samples": [
              "GSM433634",
              "GSM433635",
              "GSM433636",
              "GSM433637"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificRootView": {
    "db": "root",
    "groups": [
      {
        "name": null,
        "controls": [
          "ROOT_CTRL"
        ],
        "tissues": [
          {
            "name": "columella",
            "id": "columella_1",
            "samples": [
              "col_1"
            ]
          },
          {
            "name": "columella 1",
            "id": "columella_2",
            "samples": [
              "col_2"
            ]
          },
          {
            "name": "cortex 9",
            "id": "cortex_9",
            "samples": [
              "cortex_9"
            ]
          },
          {
            "name": "cortex 10",
            "id": "cortex_10",
            "samples": [
              "cortex_10"
            ]
          },
          {
            "name": "cortex 11",
            "id": "cortex_11",
            "samples": [
              "cortex_11"
            ]
          },
          {
            "name": "cortex 12",
            "id": "cortex_12",
            "samples": [
              "cortex_12"
            ]
          },
          {
            "name": "cortex 13",
            "id": "cortex_13",
            "samples": [
              "cortex_13"
            ]
          },
          {
            "name": "cortex 2",
            "id": "cortex_2",
            "samples": [
              "cortex_2"
            ]
          },
          {
            "name": "cortex 3",
            "id": "cortex_3",
            "samples": [
              "cortex_3"
            ]
          },
          {
            "name": "cortex 4",
            "id": "cortex_4",
            "samples": [
              "cortex_4"
            ]
          },
          {
            "name": "cortex 5",
            "id": "cortex_5",
            "samples": [
              "cortex_5"
            ]
          },
          {
            "name": "cortex 6",
            "id": "cortex_6",
            "samples": [
              "cortex_6"
            ]
          },
          {
            "name": "cortex 7",
            "id": "cortex_7",
            "samples": [
              "cortex_7"
            ]
          },
          {
            "name": "cortex 8",
            "id": "cortex_8",
            "samples": [
              "cortex_8"
            ]
          },
          {
            "name": "endodermis 9",
            "id": "endodermis_9",
            "samples": [
              "endodermis_9"
            ]
          },
          {
            "name": "endodermis 10",
            "id": "endodermis_10",
            "samples": [
              "endodermis_10"
            ]
          },
          {
            "name": "endodermis 11",
            "id": "endodermis_11",
            "samples": [
              "endodermis_11"
            ]
          },
          {
            "name": "endodermis 12",
            "id": "endodermis_12",
            "samples": [
              "endodermis_12"
            ]
          },
          {
            "name": "endodermis 13",
            "id": "endodermis_13",
            "samples": [
              "endodermis_13"
            ]
          },
          {
            "name": "endodermis 2",
            "id": "endodermis_2",
            "samples": [
              "endodermis_2"
            ]
          },
          {
            "name": "endodermis 3",
            "id": "endodermis_3",
            "samples": [
              "endodermis_3"
            ]
          },
          {
            "name": "endodermis 4",
            "id": "endodermis_4",
            "samples": [
              "endodermis_4"
            ]
          },
          {
            "name": "endodermis 5",
            "id": "endodermis_5",
            "samples": [
              "endodermis_5"
            ]
          },
          {
            "name": "endodermis 6",
            "id": "endodermis_6",
            "samples": [
              "endodermis_6"
            ]
          },
          {
            "name": "endodermis 7",
            "id": "endodermis_7",
            "samples": [
              "endodermis_7"
            ]
          },
          {
            "name": "endodermis 8",
            "id": "endodermis_8",
            "samples": [
              "endodermis_8"
            ]
          },
          {
            "name": "hair 9",
            "id": "hair_9",
            "samples": [
              "hair_9"
            ]
          },
          {
            "name": "hair 10",
            "id": "hair_10",
            "samples": [
              "hair_10"
            ]
          },
          {
            "name": "hair 11",
            "id": "hair_11",
            "samples": [
              "hair_11"
            ]
          },
          {
            "name": "hair 12",
            "id": "hair_12",
            "samples": [
              "hair_12"
            ]
          },
          {
            "name": "hair 13",
            "id": "hair_13",
            "samples": [
              "hair_13"
            ]
          },
          {
            "name": "hair 2",
            "id": "hair_2",
            "samples": [
              "hair_2"
            ]
          },
          {
            "name": "hair 3",
            "id": "hair_3",
            "samples": [
              "hair_3"
            ]
          },
          {
            "name": "hair 4",
            "id": "hair_4",
            "samples": [
              "hair_4"
            ]
          },
          {
            "name": "hair 5",
            "id": "hair_5",
            "samples": [
              "hair_5"
            ]
          },
          {
            "name": "hair 6",
            "id": "hair_6",
            "samples": [
              "hair_6"
            ]
          },
          {
            "name": "hair 7",
            "id": "hair_7",
            "samples": [
              "hair_7"
            ]
          },
          {
            "name": "hair 8",
            "id": "hair_8",
            "samples": [
              "hair_8"
            ]
          },
          {
            "name": "lateral root cap",
            "id": "lateral_root_cap_1",
            "samples": [
              "lrc_1"
            ]
          },
          {
            "name": "lateral root cap 1",
            "id": "lateral_root_cap_2",
            "samples": [
              "lrc_2"
            ]
          },
          {
            "name": "lateral root cap 2",
            "id": "lateral_root_cap_3",
            "samples": [
              "lrc_3"
            ]
          },
          {
            "name": "lateral root cap 3",
            "id": "lateral_root_cap_4",
            "samples": [
              "lrc_4"
            ]
          },
          {
            "name": "lateral root cap 4",
            "id": "lateral_root_cap_5",
            "samples": [
              "lrc_5"
            ]
          },
          {
            "name": "lateral root cap 5",
            "id": "lateral_root_cap_6",
            "samples": [
              "lrc_6"
            ]
          },
          {
            "name": "lateral root primordium 12",
            "id": "lateral_root_primordium_12",
            "samples": [
              "lrp_12"
            ]
          },
          {
            "name": "meta protophloem 9",
            "id": "meta_protophloem_9",
            "samples": [
              "metaProtoPhloem_9"
            ]
          },
          {
            "name": "meta protophloem 10",
            "id": "meta_protophloem_10",
            "samples": [
              "metaProtoPhloem_10"
            ]
          },
          {
            "name": "meta protophloem 11",
            "id": "meta_protophloem_11",
            "samples": [
              "metaProtoPhloem_11"
            ]
          },
          {
            "name": "meta protophloem 12",
            "id": "meta_protophloem_12",
            "samples": [
              "metaProtoPhloem_12"
            ]
          },
          {
            "name": "meta protophloem 13",
            "id": "meta_protophloem_13",
            "samples": [
              "metaProtoPhloem_13"
            ]
          },
          {
            "name": "meta protophloem 3",
            "id": "meta_protophloem_3",
            "samples": [
              "metaProtoPhloem_3"
            ]
          },
          {
            "name": "meta protophloem 4",
            "id": "meta_protophloem_4",
            "samples": [
              "metaProtoPhloem_4"
            ]
          },
          {
            "name": "meta protophloem 5",
            "id": "meta_protophloem_5",
            "samples": [
              "metaProtoPhloem_5"
            ]
          },
          {
            "name": "meta protophloem 6",
            "id": "meta_protophloem_6",
            "samples": [
              "metaProtoPhloem_6"
            ]
          },
          {
            "name": "meta protophloem 7",
            "id": "meta_protophloem_7",
            "samples": [
              "metaProtoPhloem_7"
            ]
          },
          {
            "name": "meta protophloem 8",
            "id": "meta_protophloem_8",
            "samples": [
              "metaProtoPhloem_8"
            ]
          },
          {
            "name": "non root hair cell 9",
            "id": "non_root_hair_cell_9",
            "samples": [
              "nonHair_9"
            ]
          },
          {
            "name": "non root hair cell 10",
            "id": "non_root_hair_cell_10",
            "samples": [
              "nonHair_10"
            ]
          },
          {
            "name": "non root hair cell 11",
            "id": "non_root_hair_cell_11",
            "samples": [
              "nonHair_11"
            ]
          },
          {
            "name": "non root hair cell 12",
            "id": "non_root_hair_cell_12",
            "samples": [
              "nonHair_12"
            ]
          },
          {
            "name": "non root hair cell 13",
            "id": "non_root_hair_cell_13",
            "samples": [
              "nonHair_13"
            ]
          },
          {
            "name": "non root hair cell 2",
            "id": "non_root_hair_cell_2",
            "samples": [
              "nonHair_2"
            ]
          },
          {
            "name": "non root hair cell 3",
            "id": "non_root_hair_cell_3",
            "samples": [
              "nonHair_3"
            ]
          },
          {
            "name": "non root hair cell 4",
            "id": "non_root_hair_cell_4",
            "samples": [
              "nonHair_4"
            ]
          },
          {
            "name": "non root hair cell 5",
            "id": "non_root_hair_cell_5",
            "samples": [
              "nonHair_5"
            ]
          },
          {
            "name": "non root hair cell 6",
            "id": "non_root_hair_cell_6",
            "samples": [
              "nonHair_6"
            ]
          },
          {
            "name": "non root hair cell 7",
            "id": "non_root_hair_cell_7",
            "samples": [
              "nonHair_7"
            ]
          },
          {
            "name": "non root hair cell 8",
            "id": "non_root_hair_cell_8",
            "samples": [
              "nonHair_8"
            ]
          },
          {
            "name": "phloem companion cell 9",
            "id": "phloem_companion_cell_9",
            "samples": [
              "phloem_9"
            ]
          },
          {
            "name": "phloem companion cell 10",
            "id": "phloem_companion_cell_10",
            "samples": [
              "phloem_10"
            ]
          },
          {
            "name": "phloem companion cell 11",
            "id": "phloem_companion_cell_11",
            "samples": [
              "phloem_11"
            ]
          },
          {
            "name": "phloem companion cell 12",
            "id": "phloem_companion_cell_12",
            "samples": [
              "phloem_12"
            ]
          },
          {
            "name": "phloem companion cell 13",
            "id": "phloem_companion_cell_13",
            "samples": [
              "phloem_13"
            ]
          },
          {
            "name": "phloem companion cell 3",
            "id": "phloem_companion_cell_3",
            "samples": [
              "phloem_3"
            ]
          },
          {
            "name": "phloem companion cell 4",
            "id": "phloem_companion_cell_4",
            "samples": [
              "phloem_4"
            ]
          },
          {
            "name": "phloem companion cell 5",
            "id": "phloem_companion_cell_5",
            "samples": [
              "phloem_5"
            ]
          },
          {
            "name": "phloem companion cell 6",
            "id": "phloem_companion_cell_6",
            "samples": [
              "phloem_6"
            ]
          },
          {
            "name": "phloem companion cell 7",
            "id": "phloem_companion_cell_7",
            "samples": [
              "phloem_7"
            ]
          },
          {
            "name": "phloem companion cell 8",
            "id": "phloem_companion_cell_8",
            "samples": [
              "phloem_8"
            ]
          },
          {
            "name": "phloem pole pericycle 9",
            "id": "phloem_pole_pericycle_9",
            "samples": [
              "phloemPole_9"
            ]
          },
          {
            "name": "phloem pole pericycle 10",
            "id": "phloem_pole_pericycle_10",
            "samples": [
              "phloemPole_10"
            ]
          },
          {
            "name": "phloem pole pericycle 11",
            "id": "phloem_pole_pericycle_11",
            "samples": [
              "phloemPole_11"
            ]
          },
          {
            "name": "phloem pole pericycle 12",
            "id": "phloem_pole_pericycle_12",
            "samples": [
              "phloemPole_12"
            ]
          },
          {
            "name": "phloem pole pericycle 13",
            "id": "phloem_pole_pericycle_13",
            "samples": [
              "phloemPole_13"
            ]
          },
          {
            "name": "phloem pole pericycle 2",
            "id": "phloem_pole_pericycle_2",
            "samples": [
              "phloemPole_2"
            ]
          },
          {
            "name": "phloem pole pericycle 3",
            "id": "phloem_pole_pericycle_3",
            "samples": [
              "phloemPole_3"
            ]
          },
          {
            "name": "phloem pole pericycle 4",
            "id": "phloem_pole_pericycle_4",
            "samples": [
              "phloemPole_4"
            ]
          },
          {
            "name": "phloem pole pericycle 5",
            "id": "phloem_pole_pericycle_5",
            "samples": [
              "phloemPole_5"
            ]
          },
          {
            "name": "phloem pole pericycle 6",
            "id": "phloem_pole_pericycle_6",
            "samples": [
              "phloemPole_6"
            ]
          },
          {
            "name": "phloem pole pericycle 7",
            "id": "phloem_pole_pericycle_7",
            "samples": [
              "phloemPole_7"
            ]
          },
          {
            "name": "phloem pole pericycle 8",
            "id": "phloem_pole_pericycle_8",
            "samples": [
              "phloemPole_8"
            ]
          },
          {
            "name": "procambium 9",
            "id": "procambium_9",
            "samples": [
              "procambium_9"
            ]
          },
          {
            "name": "procambium 10",
            "id": "procambium_10",
            "samples": [
              "procambium_10"
            ]
          },
          {
            "name": "procambium 11",
            "id": "procambium_11",
            "samples": [
              "procambium_11"
            ]
          },
          {
            "name": "procambium 12",
            "id": "procambium_12",
            "samples": [
              "procambium_12"
            ]
          },
          {
            "name": "procambium 13",
            "id": "procambium_13",
            "samples": [
              "procambium_13"
            ]
          },
          {
            "name": "procambium 2",
            "id": "procambium_2",
            "samples": [
              "procambium_2"
            ]
          },
          {
            "name": "procambium 3",
            "id": "procambium_3",
            "samples": [
              "procambium_3"
            ]
          },
          {
            "name": "procambium 4",
            "id": "procambium_4",
            "samples": [
              "procambium_4"
            ]
          },
          {
            "name": "procambium 5",
            "id": "procambium_5",
            "samples": [
              "procambium_5"
            ]
          },
          {
            "name": "procambium 6",
            "id": "procambium_6",
            "samples": [
              "procambium_6"
            ]
          },
          {
            "name": "procambium 7",
            "id": "procambium_7",
            "samples": [
              "procambium_7"
            ]
          },
          {
            "name": "procambium 8",
            "id": "procambium_8",
            "samples": [
              "procambium_8"
            ]
          },
          {
            "name": "quiescent center 2",
            "id": "quiescent_center_2",
            "samples": [
              "qc_2"
            ]
          },
          {
            "name": "xylem 9",
            "id": "xylem_9",
            "samples": [
              "xylem_9"
            ]
          },
          {
            "name": "xylem 10",
            "id": "xylem_10",
            "samples": [
              "xylem_10"
            ]
          },
          {
            "name": "xylem 11",
            "id": "xylem_11",
            "samples": [
              "xylem_11"
            ]
          },
          {
            "name": "xylem 12",
            "id": "xylem_12",
            "samples": [
              "xylem_12"
            ]
          },
          {
            "name": "xylem 13",
            "id": "xylem_13",
            "samples": [
              "xylem_13"
            ]
          },
          {
            "name": "xylem 2",
            "id": "xylem_2",
            "samples": [
              "xylem_2"
            ]
          },
          {
            "name": "xylem 3",
            "id": "xylem_3",
            "samples": [
              "xylem_3"
            ]
          },
          {
            "name": "xylem 4",
            "id": "xylem_4",
            "samples": [
              "xylem_4"
            ]
          },
          {
            "name": "xylem 5",
            "id": "xylem_5",
            "samples": [
              "xylem_5"
            ]
          },
          {
            "name": "xylem 6",
            "id": "xylem_6",
            "samples": [
              "xylem_6"
            ]
          },
          {
            "name": "xylem 7",
            "id": "xylem_7",
            "samples": [
              "xylem_7"
            ]
          },
          {
            "name": "xylem 8",
            "id": "xylem_8",
            "samples": [
              "xylem_8"
            ]
          },
          {
            "name": "xylem pole pericycle 9",
            "id": "xylem_pole_pericycle_9",
            "samples": [
              "xylemPole_9"
            ]
          },
          {
            "name": "xylem pole pericycle 10",
            "id": "xylem_pole_pericycle_10",
            "samples": [
              "xylemPole_10"
            ]
          },
          {
            "name": "xylem pole pericycle 11",
            "id": "xylem_pole_pericycle_11",
            "samples": [
              "xylemPole_11"
            ]
          },
          {
            "name": "xylem pole pericycle 12",
            "id": "xylem_pole_pericycle_12",
            "samples": [
              "xylemPole_12"
            ]
          },
          {
            "name": "xylem pole pericycle 13",
            "id": "xylem_pole_pericycle_13",
            "samples": [
              "xylemPole_13"
            ]
          },
          {
            "name": "xylem pole pericycle 2",
            "id": "xylem_pole_pericycle_2",
            "samples": [
              "xylemPole_2"
            ]
          },
          {
            "name": "xylem pole pericycle 3",
            "id": "xylem_pole_pericycle_3",
            "samples": [
              "xylemPole_3"
            ]
          },
          {
            "name": "xylem pole pericycle 4",
            "id": "xylem_pole_pericycle_4",
            "samples": [
              "xylemPole_4"
            ]
          },
          {
            "name": "xylem pole pericycle 5",
            "id": "xylem_pole_pericycle_5",
            "samples": [
              "xylemPole_5"
            ]
          },
          {
            "name": "xylem pole pericycle 6",
            "id": "xylem_pole_pericycle_6",
            "samples": [
              "xylemPole_6"
            ]
          },
          {
            "name": "xylem pole pericycle 7",
            "id": "xylem_pole_pericycle_7",
            "samples": [
              "xylemPole_7"
            ]
          },
          {
            "name": "xylem pole pericycle 8",
            "id": "xylem_pole_pericycle_8",
            "samples": [
              "xylemPole_8"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [],
        "tissues": [
          {
            "name": "Phloem Pole Pericycle, young (average of levels in PPP cells in sections 1-6)",
            "id": "Phloem_Pole_Pericycle_young_1to6",
            "samples": [
              "phloemPole_2",
              "phloemPole_3",
              "phloemPole_4",
              "phloemPole_5",
              "phloemPole_6"
            ]
          },
          {
            "name": "Xylem Pole Pericycle, young (average of levels in XPP cells in sections 1-6)",
            "id": "Xylem_Pole_Pericycle_young_1to6",
            "samples": [
              "xylemPole_2",
              "xylemPole_3",
              "xylemPole_4",
              "xylemPole_5",
              "xylemPole_6"
            ]
          },
          {
            "name": "Phloem companion cells, young (average of levels in PC cells in sections 2-6)",
            "id": "Phloem_companion_cells_young_2to6",
            "samples": [
              "phloem_2",
              "phloem_3",
              "phloem_4",
              "phloem_5",
              "phloem_6"
            ]
          },
          {
            "name": "Protophloem and Metaphloem,  young (average of phloem levels in sections 2-6)",
            "id": "Protophloem_and_Metaphloem_young2to6",
            "samples": [
              "metaProtoPhloem_2",
              "metaProtoPhloem_3",
              "metaProtoPhloem_4",
              "metaProtoPhloem_5",
              "metaProtoPhloem_6"
            ]
          },
          {
            "name": "Procambium, young (average of procambium levels in sections 1-6)",
            "id": "Procambium_young_1to6",
            "samples": [
              "procambium_2",
              "procambium_3",
              "procambium_4",
              "procambium_5",
              "procambium_6"
            ]
          },
          {
            "name": "Xylem, young (average of xylem levels in sections 1-6)",
            "id": "Xylem_young_1to6",
            "samples": [
              "xylem_2",
              "xylem_3",
              "xylem_4",
              "xylem_5",
              "xylem_6"
            ]
          },
          {
            "name": "Phloem Pole Pericycle, old (average of levels in PPP cells in sections 7-12)",
            "id": "Phloem_Pole_Pericycle_old7to12",
            "samples": [
              "phloemPole_7",
              "phloemPole_8",
              "phloemPole_9",
              "phloemPole_10",
              "phloemPole_11",
              "phloemPole_12"
            ]
          },
          {
            "name": "Xylem Pole Pericycle, old (average of levels in XPP cells in sections 7-12)",
            "id": "Xylem_Pole_Pericycle_old7to12",
            "samples": [
              "xylemPole_7",
              "xylemPole_8",
              "xylemPole_9",
              "xylemPole_10",
              "xylemPole_11",
              "xylemPole_12"
            ]
          },
          {
            "name": "Phloem companion cells, old (average of levels in PC cells in sections 7-12)",
            "id": "Phloem_companion_cells_old7to12",
            "samples": [
              "phloem_7",
              "phloem_8",
              "phloem_9",
              "phloem_10",
              "phloem_11",
              "phloem_12"
            ]
          },
          {
            "name": "Protophloem and Metaphloem, old (average of phloem levels in sections 7-12)",
            "id": "Protophloem_and_Metaphloem_old7to12",
            "samples": [
              "metaProtoPhloem_7",
              "metaProtoPhloem_8",
              "metaProtoPhloem_9",
              "metaProtoPhloem_10",
              "metaProtoPhloem_11",
              "metaProtoPhloem_12"
            ]
          },
          {
            "name": "Procambium, old (average of procambium levels in sections 7-12)",
            "id": "Procambium_old7to12",
            "samples": [
              "procambium_7",
              "procambium_8",
              "procambium_9",
              "procambium_10",
              "procambium_11",
              "procambium_12"
            ]
          },
          {
            "name": "Xylem, old (average of xylem levels in sections 7-12)",
            "id": "Xylem_old7to12",
            "samples": [
              "xylem_7",
              "xylem_8",
              "xylem_9",
              "xylem_10",
              "xylem_11",
              "xylem_12"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184925",
          "GSM184926"
        ],
        "tissues": [
          {
            "name": "Whole root, standard conditions (control)",
            "id": "Whole_root_t0_salt_control",
            "samples": [
              "GSM184925",
              "GSM184926"
            ]
          },
          {
            "name": "Whole root, 30 minutes of 140 mM NaCl exposure",
            "id": "Whole_root_30_minutes_salt",
            "samples": [
              "GSM184927",
              "GSM184928"
            ]
          },
          {
            "name": "Whole root, 1 hour of 140 mM NaCl exposure",
            "id": "Whole_root_1hr_salt",
            "samples": [
              "GSM184929",
              "GSM184930"
            ]
          },
          {
            "name": "Whole root, 4 hours of 140 mM NaCl exposure",
            "id": "Whole_root_4hrs_salt",
            "samples": [
              "GSM184931",
              "GSM184932"
            ]
          },
          {
            "name": "Whole root, 16 hours of 140 mM NaCl exposure",
            "id": "Whole_root_16hrs_salt",
            "samples": [
              "GSM184933",
              "GSM184934"
            ]
          },
          {
            "name": "Whole root, 32 hours of 140 mM NaCl exposure",
            "id": "Whole_root_32hrs_salt",
            "samples": [
              "GSM184935",
              "GSM184936"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184831",
          "GSM184832"
        ],
        "tissues": [
          {
            "name": "longitudinal zone 1, standard conditions",
            "id": "longitudinal_zone_1_salt_control",
            "samples": [
              "GSM184831",
              "GSM184832"
            ]
          },
          {
            "name": "longitudinal zone 1, 140 mM NaCl",
            "id": "longitudinal_zone_1_salt_treatment",
            "samples": [
              "GSM184839",
              "GSM184840"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184833",
          "GSM184834"
        ],
        "tissues": [
          {
            "name": "longitudinal zone 2, standard conditions",
            "id": "longitudinal_zone_2_salt_control",
            "samples": [
              "GSM184833",
              "GSM184834"
            ]
          },
          {
            "name": "longitudinal zone 2, 140 mM NaCl",
            "id": "longitudinal_zone_2_salt_treatment",
            "samples": [
              "GSM184841",
              "GSM184842"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184835",
          "GSM184836"
        ],
        "tissues": [
          {
            "name": "longitudinal zone 3, standard conditions",
            "id": "longitudinal_zone_3_salt_control",
            "samples": [
              "GSM184835",
              "GSM184836"
            ]
          },
          {
            "name": "longitudinal zone 3, 140 mM NaCl",
            "id": "longitudinal_zone_3_salt_treatment",
            "samples": [
              "GSM184843",
              "GSM184844"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184837",
          "GSM184838"
        ],
        "tissues": [
          {
            "name": "longitudinal zone 4, standard conditions",
            "id": "longitudinal_zone_4_salt_control",
            "samples": [
              "GSM184837",
              "GSM184838"
            ]
          },
          {
            "name": "longitudinal zone 4, 140 mM NaCl",
            "id": "longitudinal_zone_4_salt_treatment",
            "samples": [
              "GSM184845",
              "GSM184846"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184889",
          "GSM184890",
          "GSM184891"
        ],
        "tissues": [
          {
            "name": "epidermis and lateral root cap,  standard conditions",
            "id": "epidermis_and_lateral_root_cap_salt_control",
            "samples": [
              "GSM184889",
              "GSM184890",
              "GSM184891"
            ]
          },
          {
            "name": "epidermis and lateral root cap,  standard conditions",
            "id": "verticalCrossSection_epidermis_and_lateral_root_cap_salt_control",
            "samples": [
              "GSM184889",
              "GSM184890",
              "GSM184891"
            ]
          },
          {
            "name": "epidermis and lateral root cap, 140 mM NaCl",
            "id": "epidermis_and_lateral_root_cap_salt_treatment",
            "samples": [
              "GSM184907",
              "GSM184908",
              "GSM184909"
            ]
          },
          {
            "name": "epidermis and lateral root cap, 140 mM NaCl",
            "id": "verticalCrossSection_epidermis_and_lateral_root_cap_salt_treatment",
            "samples": [
              "GSM184907",
              "GSM184908",
              "GSM184909"
            ]
          },
          {
            "name": "epidermis and lateral root cap,  standard conditions",
            "id": "epidermis_and_lateral_root_cap_iron_control",
            "samples": [
              "GSM184889",
              "GSM184890",
              "GSM184891"
            ]
          },
          {
            "name": "epidermis and lateral root cap,  standard conditions",
            "id": "verticalCrossSection_epidermis_and_lateral_root_cap_iron_control",
            "samples": [
              "GSM184889",
              "GSM184890",
              "GSM184891"
            ]
          },
          {
            "name": "epidermis and lateral root cap, -Fe",
            "id": "epidermis_and_lateral_root_cap_iron_treatment",
            "samples": [
              "GSM266662",
              "GSM266663",
              "GSM266664",
              "GSM266665"
            ]
          },
          {
            "name": "epidermis and lateral root cap, -Fe",
            "id": "verticalCrossSection_epidermis_and_lateral_root_cap_iron_treatment",
            "samples": [
              "GSM266662",
              "GSM266663",
              "GSM266664",
              "GSM266665"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184895",
          "GSM184896",
          "GSM184897"
        ],
        "tissues": [
          {
            "name": "cortex, standard conditions",
            "id": "cortex_salt_control",
            "samples": [
              "GSM184895",
              "GSM184896",
              "GSM184897"
            ]
          },
          {
            "name": "cortex, standard conditions",
            "id": "verticalCrossSection_cortex_salt_control",
            "samples": [
              "GSM184895",
              "GSM184896",
              "GSM184897"
            ]
          },
          {
            "name": "cortex, 140 mM NaCl",
            "id": "cortex_salt_treatment",
            "samples": [
              "GSM184913",
              "GSM184914",
              "GSM184915"
            ]
          },
          {
            "name": "cortex, 140 mM NaCl",
            "id": "verticalCrossSection_cortex_salt_treatment",
            "samples": [
              "GSM184913",
              "GSM184914",
              "GSM184915"
            ]
          },
          {
            "name": "cortex, standard conditions",
            "id": "cortex_iron_control",
            "samples": [
              "GSM184895",
              "GSM184896",
              "GSM184897"
            ]
          },
          {
            "name": "cortex, standard conditions",
            "id": "verticalCrossSection_cortex_iron_control",
            "samples": [
              "GSM184895",
              "GSM184896",
              "GSM184897"
            ]
          },
          {
            "name": "cortex,  -Fe",
            "id": "cortex_iron_treatment",
            "samples": [
              "GSM266669",
              "GSM266670",
              "GSM266671"
            ]
          },
          {
            "name": "cortex,  -Fe",
            "id": "verticalCrossSection_cortex_iron_treatment",
            "samples": [
              "GSM266669",
              "GSM266670",
              "GSM266671"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184898",
          "GSM184899",
          "GSM184900"
        ],
        "tissues": [
          {
            "name": "endodermis and quiescent center,  standard conditions",
            "id": "endodermis_and_quiescent_center_salt_control",
            "samples": [
              "GSM184898",
              "GSM184899",
              "GSM184900"
            ]
          },
          {
            "name": "endodermis and quiescent center,  standard conditions",
            "id": "verticalCrossSection_endodermis_and_quiescent_center_salt_control",
            "samples": [
              "GSM184898",
              "GSM184899",
              "GSM184900"
            ]
          },
          {
            "name": "endodermis and quiescent center,  140 mM NaCl",
            "id": "endodermis_and_quiescent_center_salt_treatment",
            "samples": [
              "GSM184916",
              "GSM184917",
              "GSM184918"
            ]
          },
          {
            "name": "endodermis and quiescent center,  140 mM NaCl",
            "id": "verticalCrossSection_endodermis_and_quiescent_center_salt_treatment",
            "samples": [
              "GSM184916",
              "GSM184917",
              "GSM184918"
            ]
          },
          {
            "name": "endodermis and quiescent center,  standard conditions",
            "id": "endodermis_and_quiescent_center_iron_control",
            "samples": [
              "GSM184898",
              "GSM184899",
              "GSM184900"
            ]
          },
          {
            "name": "endodermis and quiescent center,  standard conditions",
            "id": "verticalCrossSection_endodermis_and_quiescent_center_iron_control",
            "samples": [
              "GSM184898",
              "GSM184899",
              "GSM184900"
            ]
          },
          {
            "name": "endodermis and quiescent center,  -Fe",
            "id": "endodermis_and_quiescent_center_iron_treatment",
            "samples": [
              "GSM266672",
              "GSM266673",
              "GSM266674"
            ]
          },
          {
            "name": "endodermis and quiescent center,  -Fe",
            "id": "verticalCrossSection_endodermis_and_quiescent_center_iron_treatment",
            "samples": [
              "GSM266672",
              "GSM266673",
              "GSM266674"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184901",
          "GSM184902",
          "GSM184903"
        ],
        "tissues": [
          {
            "name": "stele, standard conditions",
            "id": "stele_salt_control",
            "samples": [
              "GSM184901",
              "GSM184902",
              "GSM184903"
            ]
          },
          {
            "name": "stele, standard conditions",
            "id": "verticalCrossSection_stele_salt_control",
            "samples": [
              "GSM184901",
              "GSM184902",
              "GSM184903"
            ]
          },
          {
            "name": "stele, 140 mM NaCl",
            "id": "stele_salt_treatment",
            "samples": [
              "GSM184919",
              "GSM184920",
              "GSM184921"
            ]
          },
          {
            "name": "stele, 140 mM NaCl",
            "id": "verticalCrossSection_stele_salt_treatment",
            "samples": [
              "GSM184919",
              "GSM184920",
              "GSM184921"
            ]
          },
          {
            "name": "stele, standard conditions",
            "id": "stele_iron_control",
            "samples": [
              "GSM184901",
              "GSM184902",
              "GSM184903"
            ]
          },
          {
            "name": "stele, standard conditions",
            "id": "verticalCrossSection_stele_iron_control",
            "samples": [
              "GSM184901",
              "GSM184902",
              "GSM184903"
            ]
          },
          {
            "name": "stele, -Fe",
            "id": "stele_iron_treatment",
            "samples": [
              "GSM266675",
              "GSM266676",
              "GSM266677"
            ]
          },
          {
            "name": "stele, -Fe",
            "id": "verticalCrossSection_stele_iron_treatment",
            "samples": [
              "GSM266675",
              "GSM266676",
              "GSM266677"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184904",
          "GSM184905",
          "GSM184906"
        ],
        "tissues": [
          {
            "name": "protophloem,  standard conditions",
            "id": "protophloem_salt_control",
            "samples": [
              "GSM184904",
              "GSM184905",
              "GSM184906"
            ]
          },
          {
            "name": "protophloem,  140 mM NaCl",
            "id": "protophloem_salt_treatment",
            "samples": [
              "GSM184922",
              "GSM184923",
              "GSM184924"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184892",
          "GSM184893",
          "GSM184894"
        ],
        "tissues": [
          {
            "name": "columella root cap,  standard conditions",
            "id": "verticalCrossSection_columella_root_cap_salt_control",
            "samples": [
              "GSM184892",
              "GSM184893",
              "GSM184894"
            ]
          },
          {
            "name": "columella root cap,  140 mM NaCl",
            "id": "verticalCrossSection_columella_root_cap_salt_treatment",
            "samples": [
              "GSM184910",
              "GSM184911",
              "GSM184912"
            ]
          },
          {
            "name": "columella root cap,  standard conditions",
            "id": "verticalCrossSection_columella_root_cap_iron_control",
            "samples": [
              "GSM184892",
              "GSM184893",
              "GSM184894"
            ]
          },
          {
            "name": "columella root cap,  -Fe",
            "id": "verticalCrossSection_columella_root_cap_iron_treatment",
            "samples": [
              "GSM266666",
              "GSM266667",
              "GSM266668"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM265461",
          "GSM265462"
        ],
        "tissues": [
          {
            "name": "Whole root, standard conditions, control",
            "id": "Whole_root_t0_iron_control",
            "samples": [
              "GSM265461",
              "GSM265462"
            ]
          },
          {
            "name": "Whole root, -Fe,  3 hour",
            "id": "Whole_root_3_hrs_iron",
            "samples": [
              "GSM265463",
              "GSM265464"
            ]
          },
          {
            "name": "Whole root, -Fe,  6 hour",
            "id": "Whole_root_6_hrs_iron",
            "samples": [
              "GSM265465",
              "GSM265466"
            ]
          },
          {
            "name": "Whole root, -Fe,  12 hour",
            "id": "Whole_root_12_hrs_iron",
            "samples": [
              "GSM265467",
              "GSM265468"
            ]
          },
          {
            "name": "Whole root, -Fe,  24 hour",
            "id": "Whole_root_24_hrs_iron",
            "samples": [
              "GSM265469",
              "GSM265470"
            ]
          },
          {
            "name": "Whole root, -Fe,  48 hour",
            "id": "Whole_root_48_hrs_iron",
            "samples": [
              "GSM265471",
              "GSM265472"
            ]
          },
          {
            "name": "Whole root, -Fe,  72 hour",
            "id": "Whole_root_72_hrs_iron",
            "samples": [
              "GSM265473",
              "GSM265474"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM265418",
          "GSM265419"
        ],
        "tissues": [
          {
            "name": "longitudinal zone 1,  standard conditions",
            "id": "longitudinal_zone_1_iron_control",
            "samples": [
              "GSM265418",
              "GSM265419"
            ]
          },
          {
            "name": "longitudinal zone 1,  -Fe conditions",
            "id": "longitudinal_zone_1_iron_treatment",
            "samples": [
              "GSM265426",
              "GSM265427"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM265420",
          "GSM265421"
        ],
        "tissues": [
          {
            "name": "longitudinal zone 2,  standard conditions",
            "id": "longitudinal_zone_2_iron_control",
            "samples": [
              "GSM265420",
              "GSM265421"
            ]
          },
          {
            "name": "longitudinal zone 2,  -Fe conditions",
            "id": "longitudinal_zone_2_iron_treatment",
            "samples": [
              "GSM265428",
              "GSM265429"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM265422",
          "GSM265423"
        ],
        "tissues": [
          {
            "name": "longitudinal zone 3,  standard conditions",
            "id": "longitudinal_zone_3_iron_control",
            "samples": [
              "GSM265422",
              "GSM265423"
            ]
          },
          {
            "name": "longitudinal zone 3,  -Fe conditions",
            "id": "longitudinal_zone_3_iron_treatment",
            "samples": [
              "GSM265430",
              "GSM265431"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM265424",
          "GSM265425"
        ],
        "tissues": [
          {
            "name": "longitudinal zone 4,  standard conditions",
            "id": "longitudinal_zone_4_iron_control",
            "samples": [
              "GSM265424",
              "GSM265425"
            ]
          },
          {
            "name": "longitudinal zone 4,  -Fe conditions",
            "id": "longitudinal_zone_4_iron_treatment",
            "samples": [
              "GSM265432",
              "GSM265433"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184476",
          "GSM184477",
          "GSM184478"
        ],
        "tissues": [
          {
            "name": "Lateral Root Cap root cells 2hr KCl control treated",
            "id": "Lateral_Root_Cap_root_cells_2hr_KCl_control_treated",
            "samples": [
              "GSM184476",
              "GSM184477",
              "GSM184478"
            ]
          },
          {
            "name": "Lateral Root Cap root cells 2hr continuous KNO3 treated",
            "id": "Lateral_Root_Cap_root_cells_2hr_continuous_KNO3_treated",
            "samples": [
              "GSM184482",
              "GSM184483",
              "GSM184484"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184485",
          "GSM184486",
          "GSM184487"
        ],
        "tissues": [
          {
            "name": "Epidermis and Cortex root cells 2hr KCl control treated",
            "id": "Epidermis_and_Cortex_root_cells_2hr_KCl_control_treated",
            "samples": [
              "GSM184485",
              "GSM184486",
              "GSM184487"
            ]
          },
          {
            "name": "Epidermis and Cortex root cells 2hr continuous KNO3 treated",
            "id": "Epidermis_and_Cortex_root_cells_2hr_continuous_KNO3_treated",
            "samples": [
              "GSM184491",
              "GSM184492",
              "GSM184493"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184494",
          "GSM184495",
          "GSM184496"
        ],
        "tissues": [
          {
            "name": "Endodermis and Pericycle root cells 2hr KCl control treated",
            "id": "Endodermis_and_Pericycle_root_cells_2hr_KCl_control_treated",
            "samples": [
              "GSM184494",
              "GSM184495",
              "GSM184496"
            ]
          },
          {
            "name": "Endodermis and Pericycle root cells 2hr continuous KNO3 treated",
            "id": "Endodermis_and_Pericycle_root_cells_2hr_continuous_KNO3_treated",
            "samples": [
              "GSM184500",
              "GSM184501",
              "GSM184502"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184503",
          "GSM184504",
          "GSM184505"
        ],
        "tissues": [
          {
            "name": "Pericycle root cells 2hr KCl control treated",
            "id": "Pericycle_root_cells_2hr_KCl_control_treated",
            "samples": [
              "GSM184503",
              "GSM184504",
              "GSM184505"
            ]
          },
          {
            "name": "Pericycle root cells 2hr continuous KNO3 treated",
            "id": "Pericycle_root_cells_2hr_continuous_KNO3_treated",
            "samples": [
              "GSM184509",
              "GSM184510",
              "GSM184511"
            ]
          }
        ]
      },
      {
        "name": null,
        "controls": [
          "GSM184522",
          "GSM184523",
          "GSM184524"
        ],
        "tissues": [
          {
            "name": "Stele root cells 2hr KCl control treated",
            "id": "Stele_root_cells_2hr_KCl_control_treated",
            "samples": [
              "GSM184522",
              "GSM184523",
              "GSM184524"
            ]
          },
          {
            "name": "Stele root cells 2hr continuous KNO3 treated",
            "id": "Stele_root_cells_2hr_continuous_KNO3_treated",
            "samples": [
              "GSM184528",
              "GSM184529",
              "GSM184530"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificShootApicalMeristemView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [
          "ATGE_CTRL_7"
        ],
        "tissues": [
          {
            "name": "Central Zone",
            "id": "Central_Zone",
            "samples": [
              "GSM342138",
              "GSM342139",
              "GSM342140"
            ]
          },
          {
            "name": "Rib Meristem",
            "id": "Rib_Meristem",
            "samples": [
              "GSM342148",
              "GSM342149"
            ]
          },
          {
            "name": "Peripheral Zone",
            "id": "Peripheral_Zone",
            "samples": [
              "GSM342141",
              "GSM342142",
              "GSM342143"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificStemEpidermisView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [
          "ATGE_CTRL_7"
        ],
        "tissues": [
          {
            "name": "Stem epidermis, top of stem",
            "id": "Stem_epidermis_top_of_stem",
            "samples": [
              "841-JO",
              "842-JO"
            ]
          },
          {
            "name": "Stem epidermis, bottom of stem",
            "id": "Stem_epidermis_bottom_of_stem",
            "samples": [
              "872-JO",
              "873-JO"
            ]
          },
          {
            "name": "Whole stem, top of stem",
            "id": "Whole_stem_top_of_stem",
            "samples": [
              "839-JO",
              "840-JO"
            ]
          },
          {
            "name": "Whole stem, bottom of stem",
            "id": "Whole_stem_bottom_of_stem",
            "samples": [
              "874-JO",
              "875-JO"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificStigmaAndOvariesView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [
          "ATGE_CTRL_7"
        ],
        "tissues": [
          {
            "name": "Stigma tissue",
            "id": "Stigma_tissue",
            "samples": [
              "GSM67084",
              "GSM67086",
              "GSM67087"
            ]
          },
          {
            "name": "Ovary tissue",
            "id": "Ovary_tissue",
            "samples": [
              "GSM67078",
              "GSM67079",
              "GSM67080",
              "GSM67081"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificTrichomesView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [
          "ATGE_CTRL_7"
        ],
        "tissues": [
          {
            "name": "WT Col-0 leaves after trichome removal",
            "id": "WT_Col-0_leaves_after_trichome_removal",
            "samples": [
              "ColprocessleafArd13",
              "ColprocessleafMN3",
              "ColprocessleafMN4",
              "ColprocessleafMN5"
            ]
          },
          {
            "name": "WT Col-0 trichomes",
            "id": "WT_Col-0_trichomes",
            "samples": [
              "ColtrichomeArd1",
              "ColtrichomeArd2",
              "ColtrichomeMN12",
              "ColtrichomeMN13",
              "ColtrichomeMN2"
            ]
          },
          {
            "name": "gl3-sst mutant trichomes",
            "id": "gl3-sst_mutant_trichomes",
            "samples": [
              "DM9_sst1",
              "m1DM8sstard",
              "m1ssttr5_ATH1"
            ]
          },
          {
            "name": "gl3-sst sim double mutant trichomes",
            "id": "gl3-sst_sim_double_mutant_trichomes",
            "samples": [
              "gl3_sstsimtrichomeMN1",
              "gl3_sstsimtrichomeMN2"
            ]
          },
          {
            "name": "gl3-sst nok-1 double mutant trichomes",
            "id": "gl3-sst_nok-1_double_mutant_trichomes",
            "samples": [
              "EG_mosst1",
              "EG_mosst2",
              "EG_mosst3"
            ]
          }
        ]
      }
    ]
  },
  "TissueSpecificXylemAndCorkView": {
    "db": "atgenexp_plus",
    "groups": [
      {
        "name": "CTRL_7",
        "controls": [
          "ATGE_CTRL_7"
        ],
        "tissues": [
          {
            "name": "Xylem MYB61 knockout",
            "id": "Xylem_MYB61 knockout",
            "samples": [
              "Dubos_A-3-6kx_Rep1",
              "Dubos_A-3-6kx_Rep2",
              "Dubos_A-3-6kx_Rep3"
            ]
          },
          {
            "name": "Cork MYB61 knockout",
            "id": "Cork_MYB61_knockout",
            "samples": [
              "Dubos_A-4-6kc_Rep1",
              "Dubos_A-4-6kc_Rep2",
              "Dubos_A-4-6kc_Rep3"
            ]
          },
          {
            "name": "Xylem MYB50 knockout",
            "id": "Xylem_MYB50_knockout",
            "samples": [
              "Dubos_A-5-5kx_Rep1",
              "Dubos_A-5-5kx_Rep2",
              "Dubos_A-5-5kx_Rep3"
            ]
          },
          {
            "name": "Cork MYB50 knockout",
            "id": "Cork_MYB50_knockout",
            "samples": [
              "Dubos_A-6-5kc_Rep1",
              "Dubos_A-6-5kc_Rep2",
              "Dubos_A-6-5kc_Rep3"
            ]
          },
          {
            "name": "Xylem Col-0",
            "id": "Xylem_Col-0",
            "samples": [
              "Dubos_A-1-wtx_Rep1",
              "Dubos_A-1-wtx_Rep2",
              "Dubos_A-1-wtx_Rep3"
            ]
          },
          {
            "name": "Cork Col-0",
            "id": "Cork_Col-0",
            "samples": [
              "Dubos_A-2-wtc_Rep1",
              "Dubos_A-2-wtc_Rep2",
              "Dubos_A-2-wtc_Rep3"
            ]
          },
          {
            "name": "Hypocotyl Col-0",
            "id": "Hypocotyl_Col-0",
            "samples": [
              "Dubos_A-10-wth_Rep1",
              "Dubos_A-10-wth_Rep2",
              "Dubos_A-10-wth_Rep3"
            ]
          },
          {
            "name": "Hypocotyl Ler",
            "id": "Hypocotyl_Ler",
            "samples": [
              "Dubos_A-7-wlh_Rep1",
              "Dubos_A-7-wlh_Rep2",
              "Dubos_A-7-wlh_Rep3"
            ]
          },
          {
            "name": "Hypocotyl abi1",
            "id": "Hypocotyl_abi1",
            "samples": [
              "Dubos_A-8-aih_Rep1",
              "Dubos_A-8-aih_Rep2",
              "Dubos_A-8-aih_Rep3"
            ]
          },
          {
            "name": "Hypocotyl aba1",
            "id": "Hypocotyl_aba1",
            "samples": [
              "Dubos_A-9-aah_Rep1",
              "Dubos_A-9-aah_Rep2",
              "Dubos_A-9-aah_Rep3"
            ]
          },
          {
            "name": "Hypocotyl max4",
            "id": "Hypocotyl_max4",
            "samples": [
              "Dubos_A-11-mxh_Rep1",
              "Dubos_A-11-mxh_Rep2",
              "Dubos_A-11-mxh_Rep3"
            ]
          },
          {
            "name": "Hypocotyl axr1",
            "id": "Hypocotyl_axr1",
            "samples": [
              "Dubos_A-12-arh_Rep1",
              "Dubos_A-12-arh_Rep2",
              "Dubos_A-12-arh_Rep3"
            ]
          }
        ]
      }
    ]
  },
  "BioticStressBotrytiscinereaView": {
    "db": "atgenexp_pathogen",
    "groups": [
      {
        "name": "Botrytis cinerea at 18 Hours",
        "controls": [
          "CT181-1",
          "CT181-2",
          "CT182-1"
        ],
        "tissues": [
          {
            "name": "Control Botrytis cinerea at 18 Hours",
            "id": "Control_Botrytis_cinerea_at_18_Hours",
            "samples": [
              "CT181-1",
              "CT181-2",
              "CT182-1"
            ]
          },
          {
            "name": "Treated Botrytis cinerea at 18 Hours",
            "id": "Treated_Botrytis_cinerea_at_18_Hours",
            "samples": [
              "BC181-1",
              "BC181-2",
              "BC182-1"
            ]
          }
        ]
      },
      {
        "name": "Botrytis cinerea at 48 Hours",
        "controls": [
          "CT481-1",
          "CT482-1",
          "CT482-2"
        ],
        "tissues": [
          {
            "name": "Control Botrytis cinerea at 48 Hours",
            "id": "Control_Botrytis_cinerea_at_48_Hours",
            "samples": [
              "CT481-1",
              "CT482-1",
              "CT482-2"
            ]
          },
          {
            "name": "Treated Botrytis cinerea at 48 Hours",
            "id": "Treated_Botrytis_cinerea_at_48_Hours",
            "samples": [
              "BC481-1",
              "BC482-1",
              "BC482-2"
            ]
          }
        ]
      }
    ]
  },
  "BioticStressElicitorsView": {
    "db": "atgenexp_pathogen",
    "groups": [
      {
        "name": "Water Controlled Botrytis cinereaerial Elicitors at 1 Hour",
        "controls": [
          "AtGen_B-1_1-1-1_REP_1_ATH1",
          "AtGen_B-15_2-1-1_REP2_ATH1",
          "AtGen_B-29_3-1-1_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "H2O at 1 Hour",
            "id": "H2O_at_1_Hour",
            "samples": [
              "AtGen_B-1_1-1-1_REP_1_ATH1",
              "AtGen_B-15_2-1-1_REP2_ATH1",
              "AtGen_B-29_3-1-1_REP3_ATH1"
            ]
          },
          {
            "name": "FLG22 at 1 Hour",
            "id": "FLG22_at_1_Hour",
            "samples": [
              "AtGen_B-6_1-6-1_REP_1_ATH1",
              "AtGen_B-20_2-6-1_REP2_ATH1",
              "AtGen_B-34_3-6-1_REP3_ATH1"
            ]
          },
          {
            "name": "HrpZ at 1 Hour",
            "id": "HrpZ_at_1_Hour",
            "samples": [
              "AtGen_B-4_1-4-1_REP_1_ATH1",
              "AtGen_B-18_2-4-1_REP2_ATH1",
              "AtGen_B-32_3-4-1_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Ca+Mg Controlled Botrytis cinereaerial Elicitors at 1 Hour",
        "controls": [
          "AtGen_B-2_1-2-1_REP_1_ATH1",
          "AtGen_B-16_2-2-1_REP2_ATH1",
          "AtGen_B-30_3-2-1_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "Ca+Mg at 1 Hour",
            "id": "CaMg_at_1_Hour",
            "samples": [
              "AtGen_B-2_1-2-1_REP_1_ATH1",
              "AtGen_B-16_2-2-1_REP2_ATH1",
              "AtGen_B-30_3-2-1_REP3_ATH1"
            ]
          },
          {
            "name": "LPS at 1 Hour",
            "id": "LPS_at_1_Hour",
            "samples": [
              "AtGen_B-7_1-7-1_REP_1_ATH1",
              "AtGen_B-21_2-7-1_REP2_ATH1",
              "AtGen_B-35_3-7-1_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Oomycete Elicitors at 1 Hour",
        "controls": [
          "AtGen_B-3_1-3-1_REP_1_ATH1",
          "AtGen_B-17_2-3-1_REP2_ATH1",
          "AtGen_B-31_3-3-1_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "GST at 1 Hour",
            "id": "GST_at_1_Hour",
            "samples": [
              "AtGen_B-3_1-3-1_REP_1_ATH1",
              "AtGen_B-17_2-3-1_REP2_ATH1",
              "AtGen_B-31_3-3-1_REP3_ATH1"
            ]
          },
          {
            "name": "NPP at 1 Hour",
            "id": "NPP_at_1_Hour",
            "samples": [
              "AtGen_B-5_1-5-1_REP_1_ATH1",
              "AtGen_B-19_2-5-1_REP2_ATH1",
              "AtGen_B-33_3-5-1_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Water Controlled Botrytis cinereaerial Elicitors at 4 Hours",
        "controls": [
          "AtGen_B-8_1-1-4_REP_1_ATH1",
          "AtGen_B-22_2-1-4_REP2_ATH1",
          "AtGen_B-36_3-1-4_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "H2O at 4 Hours",
            "id": "H2O_at_4_Hours",
            "samples": [
              "AtGen_B-8_1-1-4_REP_1_ATH1",
              "AtGen_B-22_2-1-4_REP2_ATH1",
              "AtGen_B-36_3-1-4_REP3_ATH1"
            ]
          },
          {
            "name": "FLG22 at 4 Hours",
            "id": "FLG22_at_4_Hours",
            "samples": [
              "AtGen_B-13_1-6-4_REP1_ATH1",
              "AtGen_B-27_2-6-4_REP2_ATH1",
              "AtGen_B-41_3-6-4_REP3_ATH1"
            ]
          },
          {
            "name": "HrpZ at 4 Hours",
            "id": "HrpZ_at_4_Hours",
            "samples": [
              "AtGen_B-11_1-4-4_REP1_ATH1",
              "AtGen_B-25_2-4-4_REP2_ATH1",
              "AtGen_B-39_3-4-4_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Ca+Mg Controlled Botrytis cinereaerial Elicitors at 4 Hours",
        "controls": [
          "AtGen_B-9_1-2-4_REP_1_ATH1",
          "AtGen_B-23_2-2-4_REP2_ATH1",
          "AtGen_B-37_3-2-4_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "CaMg at 4 Hours",
            "id": "CaMg_at_4_Hours",
            "samples": [
              "AtGen_B-9_1-2-4_REP_1_ATH1",
              "AtGen_B-23_2-2-4_REP2_ATH1",
              "AtGen_B-37_3-2-4_REP3_ATH1"
            ]
          },
          {
            "name": "LPS at 4 Hours",
            "id": "LPS_at_4_Hours",
            "samples": [
              "AtGen_B-14_1-7-4_REP1_ATH1",
              "AtGen_B-28_2-7-4_REP2_ATH1",
              "AtGen_B-42_3-7-4_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Oomycete Elicitors at 4 Hours",
        "controls": [
          "AtGen_B-10_1-3-4_REP1_ATH1",
          "AtGen_B-24_2-3-4_REP2_ATH1",
          "AtGen_B-38_3-3-4_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "GST at 4 Hours",
            "id": "GST_at_4_Hours",
            "samples": [
              "AtGen_B-10_1-3-4_REP1_ATH1",
              "AtGen_B-24_2-3-4_REP2_ATH1",
              "AtGen_B-38_3-3-4_REP3_ATH1"
            ]
          },
          {
            "name": "NPP at 4 Hours",
            "id": "NPP_at_4_Hours",
            "samples": [
              "AtGen_B-12_1-5-4_REP1_ATH1",
              "AtGen_B-26_2-5-4_REP2_ATH1",
              "AtGen_B-40_3-5-4_REP3_ATH1"
            ]
          }
        ]
      }
    ]
  },
  "BioticStressErysipheorontiiView": {
    "db": "atgenexp_pathogen",
    "groups": [
      {
        "name": "Erysiphe orontii at 6 Hours",
        "controls": [
          "JD AT+EO COL WT 06H UNINFECTED",
          "JD AT+EO COL WT EXP2 06H UNINFECTED",
          "JD AT+EO TIME EXP3 UNINF 6H"
        ],
        "tissues": [
          {
            "name": "Control Erysiphe orontii at 6 Hours",
            "id": "Control_Erysiphe_orontii_at_6_Hours",
            "samples": [
              "JD AT+EO COL WT 06H UNINFECTED",
              "JD AT+EO COL WT EXP2 06H UNINFECTED",
              "JD AT+EO TIME EXP3 UNINF 6H"
            ]
          },
          {
            "name": "Treated Erysiphe orontii at 6 Hours",
            "id": "Treated_Erysiphe_orontii_at_6_Hours",
            "samples": [
              "JD AT+EO COL WT 06H INFECTED",
              "JD AT+EO COL WT EXP2 06H INFECTED",
              "JD AT+EO TIME EXP3 EO INF 6H"
            ]
          }
        ]
      },
      {
        "name": "Erysiphe orontii at 12 Hours",
        "controls": [
          "JD AT+EO COL WT 12H UNINFECTED",
          "JD AT+EO COL WT EXP2 12H UNINFECTED",
          "JD AT+EO TIME EXP3 UNINF 12H"
        ],
        "tissues": [
          {
            "name": "Control Erysiphe orontii at 12 Hours",
            "id": "Control_Erysiphe_orontii_at_12_Hours",
            "samples": [
              "JD AT+EO COL WT 12H UNINFECTED",
              "JD AT+EO COL WT EXP2 12H UNINFECTED",
              "JD AT+EO TIME EXP3 UNINF 12H"
            ]
          },
          {
            "name": "Treated Erysiphe orontii at 12 Hours",
            "id": "Treated_Erysiphe_orontii_at_12_Hours",
            "samples": [
              "JD AT+EO COL WT 12H INFECTED",
              "JD AT+EO COL WT EXP2 12H INFECTED",
              "JD AT+EO TIME EXP3 EO INF 12H"
            ]
          }
        ]
      },
      {
        "name": "Erysiphe orontii at 18 Hours",
        "controls": [
          "JD AT+EO COL WT 18H UNINFECTED",
          "JD AT+EO COL WT EXP2 18H UNINFECTED",
          "JD AT+EO TIME EXP3 UNINF 18H"
        ],
        "tissues": [
          {
            "name": "Control Erysiphe orontii at 18 Hours",
            "id": "Control_Erysiphe_orontii_at_18_Hours",
            "samples": [
              "JD AT+EO COL WT 18H UNINFECTED",
              "JD AT+EO COL WT EXP2 18H UNINFECTED",
              "JD AT+EO TIME EXP3 UNINF 18H"
            ]
          },
          {
            "name": "Treated Erysiphe orontii at 18 Hours",
            "id": "Treated_Erysiphe_orontii_at_18_Hours",
            "samples": [
              "JD AT+EO COL WT 18H INFECTED",
              "JD AT+EO COL WT EXP2 18H INFECTED",
              "JD AT+EO TIME EXP3 EO INF 18H"
            ]
          }
        ]
      },
      {
        "name": "Erysiphe orontii at 24 Hours",
        "controls": [
          "JD AT+EO COL WT 24H UNINFECTED",
          "JD AT+EO COL WT EXP2 24H UNINFECTED",
          "JD AT+EO TIME EXP3 UNINF 24H"
        ],
        "tissues": [
          {
            "name": "Control Erysiphe orontii at 24 Hours",
            "id": "Control_Erysiphe_orontii_at_24_Hours",
            "samples": [
              "JD AT+EO COL WT 24H UNINFECTED",
              "JD AT+EO COL WT EXP2 24H UNINFECTED",
              "JD AT+EO TIME EXP3 UNINF 24H"
            ]
          },
          {
            "name": "Treated Erysiphe orontii at 24 Hours",
            "id": "Treated_Erysiphe_orontii_at_24_Hours",
            "samples": [
              "JD AT+EO COL WT 24H INFECTED",
              "JD AT+EO COL WT EXP2 24H INFECTED",
              "JD AT+EO TIME EXP3 EO INF 24H"
            ]
          }
        ]
      },
      {
        "name": "Erysiphe orontii at 48 Hours",
        "controls": [
          "JD AT+EO COL WT 02D UNINFECTED",
          "JD AT+EO COL WT EXP2 02D UNINFECTED",
          "JD AT+EO TIME EXP3 UNINF 2D"
        ],
        "tissues": [
          {
            "name": "Control Erysiphe orontii at 48 Hours",
            "id": "Control_Erysiphe_orontii_at_48_Hours",
            "samples": [
              "JD AT+EO COL WT 02D UNINFECTED",
              "JD AT+EO COL WT EXP2 02D UNINFECTED",
              "JD AT+EO TIME EXP3 UNINF 2D"
            ]
          },
          {
            "name": "Treated Erysiphe orontii at 48 Hours",
            "id": "Treated_Erysiphe_orontii_at_48_Hours",
            "samples": [
              "JD AT+EO COL WT 02D INFECTED",
              "JD AT+EO COL WT EXP2 02D INFECTED",
              "JD AT+EO TIME EXP3 EO INF 2D"
            ]
          }
        ]
      },
      {
        "name": "Erysiphe orontii at 72 Hours",
        "controls": [
          "JD AT+EO COL WT 03D UNINFECTED",
          "JD AT+EO COL WT EXP2 03D UNINFECTED",
          "JD AT+EO TIME EXP3 UNINF 3D"
        ],
        "tissues": [
          {
            "name": "Control Erysiphe orontii at 72 Hours",
            "id": "Control_Erysiphe_orontii_at_72_Hours",
            "samples": [
              "JD AT+EO COL WT 03D UNINFECTED",
              "JD AT+EO COL WT EXP2 03D UNINFECTED",
              "JD AT+EO TIME EXP3 UNINF 3D"
            ]
          },
          {
            "name": "Treated Erysiphe orontii at 72 Hours",
            "id": "Treated_Erysiphe_orontii_at_72_Hours",
            "samples": [
              "JD AT+EO COL WT 03D INFECTED",
              "JD AT+EO COL WT EXP2 03D INFECTED",
              "JD AT+EO TIME EXP3 EO INF 3D"
            ]
          }
        ]
      },
      {
        "name": "Erysiphe orontii at 96 Hours",
        "controls": [
          "JD AT+EO COL WT 04D UNINFECTED",
          "JD AT+EO COL WT EXP2 04D UNINFECTED",
          "JD AT+EO TIME EXP3 UNINF 4D"
        ],
        "tissues": [
          {
            "name": "Control Erysiphe orontii at 96 Hours",
            "id": "Control_Erysiphe_orontii_at_96_Hours",
            "samples": [
              "JD AT+EO COL WT 04D UNINFECTED",
              "JD AT+EO COL WT EXP2 04D UNINFECTED",
              "JD AT+EO TIME EXP3 UNINF 4D"
            ]
          },
          {
            "name": "Treated Erysiphe orontii at 96 Hours",
            "id": "Treated_Erysiphe_orontii_at_96_Hours",
            "samples": [
              "JD AT+EO COL WT 04D INFECTED",
              "JD AT+EO COL WT EXP2 04D INFECTED",
              "JD AT+EO TIME EXP3 EO INF 4D"
            ]
          }
        ]
      },
      {
        "name": "Erysiphe orontii at 120 Hours",
        "controls": [
          "JD AT+EO COL WT 05D UNINFECTED",
          "JD AT+EO COL WT EXP2 05D UNINFECTED",
          "JD AT+EO TIME EXP3 UNINF 5D"
        ],
        "tissues": [
          {
            "name": "Control Erysiphe orontii at 120 Hours",
            "id": "Control_Erysiphe_orontii_at_120_Hours",
            "samples": [
              "JD AT+EO COL WT 05D UNINFECTED",
              "JD AT+EO COL WT EXP2 05D UNINFECTED",
              "JD AT+EO TIME EXP3 UNINF 5D"
            ]
          },
          {
            "name": "Treated Erysiphe orontii at 120 Hours",
            "id": "Treated_Erysiphe_orontii_at_120_Hours",
            "samples": [
              "JD AT+EO COL WT 05D INFECTED",
              "JD AT+EO COL WT EXP2 05D INFECTED",
              "JD AT+EO TIME EXP3 EO INF 5D"
            ]
          }
        ]
      }
    ]
  },
  "BioticStressHyaloperonosporaarabidopsidisView": {
    "db": "atgenexp_pathogen",
    "groups": [
      {
        "name": "GSM554311_WT_Emwa1_0dpi_rep2",
        "controls": [
          "GSM554311_WT_Emwa1_0dpi_rep2"
        ],
        "tissues": [
          {
            "name": "WT_Emwa1_0dpi_rep1+rep2",
            "id": "WT_Emwa1_0dpi_rep1_rep2",
            "samples": [
              "GSM554311_WT_Emwa1_0dpi_rep1",
              "GSM554311_WT_Emwa1_0dpi_rep2"
            ]
          },
          {
            "name": "WT_Emwa1_0.5dpi_rep1+rep2",
            "id": "WT_Emwa1_05dpi_rep1_rep2",
            "samples": [
              "GSM554312_WT_Emwa1_0.5dpi_rep2"
            ]
          },
          {
            "name": "WT_Emwa1_2dpi_rep1+rep2",
            "id": "WT_Emwa1_2dpi_rep1_rep2",
            "samples": [
              "GSM554313_WT_Emwa1_2dpi_rep1",
              "GSM554313_WT_Emwa1_2dpi_rep2"
            ]
          },
          {
            "name": "WT_Emwa1_4dpi_rep1+rep2",
            "id": "WT_Emwa1_4dpi_rep1_rep2",
            "samples": [
              "GSM554314_WT_Emwa1_4dpi_rep1",
              "GSM554314_WT_Emwa1_4dpi_rep2"
            ]
          },
          {
            "name": "WT_Emwa1_6dpi_rep1+rep2",
            "id": "WT_Emwa1_6dpi_rep1_rep2",
            "samples": [
              "GSM554315_WT_Emwa1_6dpi_rep1",
              "GSM554315_WT_Emwa1_6dpi_rep2"
            ]
          }
        ]
      },
      {
        "name": "GSM554316_rpp4_Emwa1_0dpi_rep1;GSM554316_rpp4_Emwa1_0dpi_rep2",
        "controls": [
          "GSM554316_rpp4_Emwa1_0dpi_rep1",
          "GSM554316_rpp4_Emwa1_0dpi_rep2"
        ],
        "tissues": [
          {
            "name": "rpp4_Emwa1_0dpi_rep1+rep2",
            "id": "rpp4_Emwa1_0dpi_rep1_rep2",
            "samples": [
              "GSM554316_rpp4_Emwa1_0dpi_rep1",
              "GSM554316_rpp4_Emwa1_0dpi_rep2"
            ]
          },
          {
            "name": "rpp4_Emwa1_0.5dpi_rep1+rep2",
            "id": "rpp4_Emwa1_05dpi_rep1_rep2",
            "samples": [
              "GSM554317_rpp4_Emwa1_0.5dpi_rep1",
              "GSM554317_rpp4_Emwa1_0.5dpi_rep2"
            ]
          },
          {
            "name": "rpp4_Emwa1_2dpi_rep1+rep2",
            "id": "rpp4_Emwa1_2dpi_rep1_rep2",
            "samples": [
              "GSM554318_rpp4_Emwa1_2dpi_rep1",
              "GSM554318_rpp4_Emwa1_2dpi_rep2"
            ]
          },
          {
            "name": "rpp4_Emwa1_4dpi_rep1+rep2",
            "id": "rpp4_Emwa1_4dpi_rep1_rep2",
            "samples": [
              "GSM554319_rpp4_Emwa1_4dpi_rep1",
              "GSM554319_rpp4_Emwa1_4dpi_rep2"
            ]
          },
          {
            "name": "rpp4_Emwa1_6dpi_rep1+rep2",
            "id": "rpp4_Emwa1_6dpi_rep1_rep2",
            "samples": [
              "GSM554320_rpp4_Emwa1_6dpi_rep1",
              "GSM554320_rpp4_Emwa1_6dpi_rep2"
            ]
          }
        ]
      }
    ]
  },
  "BioticStressMyzuspersicaereView": {
    "db": "atgenexp_pathogen",
    "groups": [
      {
        "name": "GSM157299;GSM157300;GSM157301",
        "controls": [
          "GSM157299_JPritchard_A-1_CTR_Rep1_ATH1",
          "GSM157300_JPritchard_A-2_CTR_Rep2_ATH1",
          "GSM157301_Pritchard_A-3_CTR_Rep3_ATH1"
        ],
        "tissues": [
          {
            "name": "Control",
            "id": "Control",
            "samples": [
              "GSM157299_JPritchard_A-1_CTR_Rep1_ATH1",
              "GSM157300_JPritchard_A-2_CTR_Rep2_ATH1",
              "GSM157301_Pritchard_A-3_CTR_Rep3_ATH1"
            ]
          },
          {
            "name": "Aphid infested",
            "id": "Aphid_infested",
            "samples": [
              "GSM157303_JPritchard_A-5_API_Rep2_ATH1",
              "GSM157304_JPritchard_A-6_API_Rep3_ATH1"
            ]
          }
        ]
      }
    ]
  },
  "BioticStressPhytophthorainfestansView": {
    "db": "atgenexp_pathogen",
    "groups": [
      {
        "name": "Phytophthora infestans at 6 Hours",
        "controls": [
          "AtGen_C-1_1-C-6_REP1_ATH1",
          "AtGen_C-2_2-C-6_REP2_ATH1",
          "AtGen_C-3_4-C-6_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "Control Phytophthora infestans at 6 Hours",
            "id": "Control_Phytophthora_infestans_at_6_Hours",
            "samples": [
              "AtGen_C-1_1-C-6_REP1_ATH1",
              "AtGen_C-2_2-C-6_REP2_ATH1",
              "AtGen_C-3_4-C-6_REP3_ATH1"
            ]
          },
          {
            "name": "Treated Phytophthora infestans at 6 Hours",
            "id": "Treated_Phytophthora_infestans_at_6_Hours",
            "samples": [
              "AtGen_C-10_1-Pi-6_REP1_ATH1",
              "AtGen_C-11_2-Pi-6_REP2_ATH1",
              "AtGen_C-12_3-Pi-6_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Phytophthora infestans at 12 Hours",
        "controls": [
          "AtGen_C-4_1-C-12_REP1_ATH1",
          "AtGen_C-5_2-C-12_REP2_ATH1",
          "AtGen_C-6_3-C-12_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "Control Phytophthora infestans at 12 Hours",
            "id": "Control_Phytophthora_infestans_at_12_Hours",
            "samples": [
              "AtGen_C-4_1-C-12_REP1_ATH1",
              "AtGen_C-5_2-C-12_REP2_ATH1",
              "AtGen_C-6_3-C-12_REP3_ATH1"
            ]
          },
          {
            "name": "Treated Phytophthora infestans at 12 Hours",
            "id": "Treated_Phytophthora_infestans_at_12_Hours",
            "samples": [
              "AtGen_C-13_1-Pi-12_REP1_ATH1",
              "AtGen_C-14_2-Pi-12_REP2_ATH1",
              "AtGen_C-15_3-Pi-12_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Phytophthora infestans at 24 Hours",
        "controls": [
          "AtGen_C-7_1-C-24_REP1_ATH1",
          "AtGen_C-8_2-C-24_REP2_ATH1",
          "AtGen_C-9_3-C-24_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "Control Phytophthora infestans at 24 Hours",
            "id": "Control_Phytophthora_infestans_at_24_Hours",
            "samples": [
              "AtGen_C-7_1-C-24_REP1_ATH1",
              "AtGen_C-8_2-C-24_REP2_ATH1",
              "AtGen_C-9_3-C-24_REP3_ATH1"
            ]
          },
          {
            "name": "Treated Phytophthora infestans at 24 Hours",
            "id": "Treated_Phytophthora_infestans_at_24_Hours",
            "samples": [
              "AtGen_C-16_1-Pi-24_REP1_ATH1",
              "AtGen_C-17_2-Pi-24_REP2_ATH1",
              "AtGen_C-18_3-Pi-24_REP3_ATH1"
            ]
          }
        ]
      }
    ]
  },
  "BioticStressPseudomonassyringaeView": {
    "db": "atgenexp_pathogen",
    "groups": [
      {
        "name": "Half Leaf Pseudomonas syringae at 4 Hours",
        "controls": [
          "2505",
          "2795"
        ],
        "tissues": [
          {
            "name": "Control Half Leaf Pseudomonas syringae at 4 Hours",
            "id": "Control_Half_Leaf_Pseudomonas_syringae_at_4_Hours",
            "samples": [
              "2505",
              "2795"
            ]
          },
          {
            "name": "Avirulent Half Leaf Pseudomonas syringae at 4 Hours",
            "id": "Avirulent_Half_Leaf_Pseudomonas_syringae_at_4_Hours",
            "samples": [
              "2504",
              "2796"
            ]
          },
          {
            "name": "Virulent Half Leaf Pseudomonas syringae at 4 Hours",
            "id": "Virulent_Half_Leaf_Pseudomonas_syringae_at_4_Hours",
            "samples": [
              "2530",
              "2797"
            ]
          }
        ]
      },
      {
        "name": "Half Leaf Pseudomonas syringae at 8 Hours",
        "controls": [
          "2507",
          "2792"
        ],
        "tissues": [
          {
            "name": "Control Half Leaf Pseudomonas syringae at 8 Hours",
            "id": "Control_Half_Leaf_Pseudomonas_syringae_at_8_Hours",
            "samples": [
              "2507",
              "2792"
            ]
          },
          {
            "name": "Avirulent Half Leaf Pseudomonas syringae at 8 Hours",
            "id": "Avirulent_Half_Leaf_Pseudomonas_syringae_at_8_Hours",
            "samples": [
              "2506",
              "2793"
            ]
          },
          {
            "name": "Virulent Half Leaf Pseudomonas syringae at 8 Hours",
            "id": "Virulent_Half_Leaf_Pseudomonas_syringae_at_8_Hours",
            "samples": [
              "2529",
              "2794"
            ]
          }
        ]
      },
      {
        "name": "Half Leaf Pseudomonas syringae at 16 Hours",
        "controls": [
          "2527",
          "2789"
        ],
        "tissues": [
          {
            "name": "Control Half Leaf Pseudomonas syringae at 16 Hours",
            "id": "Control_Half_Leaf_Pseudomonas_syringae_at_16_Hours",
            "samples": [
              "2527",
              "2789"
            ]
          },
          {
            "name": "Avirulent Half Leaf Pseudomonas syringae at 16 Hours",
            "id": "Avirulent_Half_Leaf_Pseudomonas_syringae_at_16_Hours",
            "samples": [
              "2508",
              "2790"
            ]
          },
          {
            "name": "Virulent Half Leaf Pseudomonas syringae at 16 Hours",
            "id": "Virulent_Half_Leaf_Pseudomonas_syringae_at_16_Hours",
            "samples": [
              "2528",
              "2791"
            ]
          }
        ]
      },
      {
        "name": "Half Leaf Pseudomonas syringae at 24 Hours",
        "controls": [
          "2510",
          "2786"
        ],
        "tissues": [
          {
            "name": "Control Half Leaf Pseudomonas syringae at 24 Hours",
            "id": "Control_Half_Leaf_Pseudomonas_syringae_at_24_Hours",
            "samples": [
              "2510",
              "2786"
            ]
          },
          {
            "name": "Avirulent Half Leaf Pseudomonas syringae at 24 Hours",
            "id": "Avirulent_Half_Leaf_Pseudomonas_syringae_at_24_Hours",
            "samples": [
              "2509",
              "2787"
            ]
          },
          {
            "name": "Virulent Half Leaf Pseudomonas syringae at 24 Hours",
            "id": "Virulent_Half_Leaf_Pseudomonas_syringae_at_24_Hours",
            "samples": [
              "2526",
              "2788"
            ]
          }
        ]
      },
      {
        "name": "Half Leaf Pseudomonas syringae at 48 Hours",
        "controls": [
          "2512",
          "2783"
        ],
        "tissues": [
          {
            "name": "Control Half Leaf Pseudomonas syringae at 48 Hours",
            "id": "Control_Half_Leaf_Pseudomonas_syringae_at_48_Hours",
            "samples": [
              "2512",
              "2783"
            ]
          },
          {
            "name": "Avirulent Half Leaf Pseudomonas syringae at 48 Hours",
            "id": "Avirulent_Half_Leaf_Pseudomonas_syringae_at_48_Hours",
            "samples": [
              "2511",
              "2784"
            ]
          },
          {
            "name": "Virulent Half Leaf Pseudomonas syringae at 48 Hours",
            "id": "Virulent_Half_Leaf_Pseudomonas_syringae_at_48_Hours",
            "samples": [
              "2525",
              "2785"
            ]
          }
        ]
      },
      {
        "name": "Infiltrating Pseudomonas syringae at 2 Hours",
        "controls": [
          "AtGen_A-53_33-1_REP1_ATH1",
          "AtGen_A-54_33-2_REP2_ATH1",
          "AtGen_A-55_33-3_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "Control Pseudomonas syringae at 2 Hours",
            "id": "Control_Pseudomonas_syringae_at_2_Hours",
            "samples": [
              "AtGen_A-53_33-1_REP1_ATH1",
              "AtGen_A-54_33-2_REP2_ATH1",
              "AtGen_A-55_33-3_REP3_ATH1"
            ]
          },
          {
            "name": "Virulent Pseudomonas syringae at 2 Hours",
            "id": "Virulent_Pseudomonas_syringae_at_2_Hours",
            "samples": [
              "AtGen_A-5_21-1_REP1_ATH1",
              "AtGen_A-6_21-2_REP2_ATH1",
              "AtGen_A-8_21-4_REP3_ATH1"
            ]
          },
          {
            "name": "Avirulent Pseudomonas syringae at 2 Hours",
            "id": "Avirulent_Pseudomonas_syringae_at_2_Hours",
            "samples": [
              "AtGen_A-17_24-1_REP1_ATH1",
              "AtGen_A-18_24-2_REP2_ATH1",
              "AtGen_A-19_24-3_REP3_ATH1"
            ]
          },
          {
            "name": "Deficient Pseudomonas syringae at 2 Hours",
            "id": "Deficient_Pseudomonas_syringae_at_2_Hours",
            "samples": [
              "AtGen_A-29_27-1_REP1_ATH1",
              "AtGen_A-30_27-2_REP2_ATH1",
              "AtGen_A-31-27-3_REP3_ATH1"
            ]
          },
          {
            "name": "Nonhost Pseudomonas syringae at 2 Hours",
            "id": "Nonhost_Pseudomonas_syringae_at_2_Hours",
            "samples": [
              "AtGen_A-41_30-1_REP1_ATH1",
              "AtGen_A-42_30-2_REP2_ATH1",
              "AtGen_A-43_30-3_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Infiltrating Pseudomonas syringae at 6 Hours",
        "controls": [
          "AtGen_A-58_34-2_REP1_ATH1",
          "AtGen_A-59_34-3_REP2_ATH1",
          "AtGen_A-60_34-4_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "Control Pseudomonas syringae at 6 Hours",
            "id": "Control_Pseudomonas_syringae_at_6_Hours",
            "samples": [
              "AtGen_A-58_34-2_REP1_ATH1",
              "AtGen_A-59_34-3_REP2_ATH1",
              "AtGen_A-60_34-4_REP3_ATH1"
            ]
          },
          {
            "name": "Virulent Pseudomonas syringae at 6 Hours",
            "id": "Virulent_Pseudomonas_syringae_at_6_Hours",
            "samples": [
              "AtGen_A-9_22-1_REP1_ATH1",
              "AtGen_A-10_22-2_REP2_ATH1",
              "AtGen_A-11_22-3_REP3_ATH1"
            ]
          },
          {
            "name": "Avirulent Pseudomonas syringae at 6 Hours",
            "id": "Avirulent_Pseudomonas_syringae_at_6_Hours",
            "samples": [
              "AtGen_A-21_25-1_REP1_ATH1",
              "AtGen_A-23_25-3_REP2_ATH1",
              "AtGen_A-24_25-4_REP3_ATH1"
            ]
          },
          {
            "name": "Deficient Pseudomonas syringae at 6 Hours",
            "id": "Deficient_Pseudomonas_syringae_at_6_Hours",
            "samples": [
              "AtGen_A-33_28-1_REP1_ATH1",
              "AtGen_A-34_28-2_REP2_ATH1",
              "AtGen_A-35_28-3_REP3_ATH1"
            ]
          },
          {
            "name": "Nonhost Pseudomonas syringae at 6 Hours",
            "id": "Nonhost_Pseudomonas_syringae_at_6_Hours",
            "samples": [
              "AtGen_A-45_31-1_REP1_ATH1",
              "AtGen_A-46_31-2_REP2_ATH1",
              "AtGen_A-48_31-4_REP3_ATH1"
            ]
          }
        ]
      },
      {
        "name": "Infiltrating Pseudomonas syringae at 24 Hours",
        "controls": [
          "AtGen_A-61_35-1_REP1_ATH1",
          "AtGen_A-62_35-2_REP2_ATH1",
          "AtGen_A-64_35-4_REP3_ATH1"
        ],
        "tissues": [
          {
            "name": "Control Pseudomonas syringae at 24 Hours",
            "id": "Control_Pseudomonas_syringae_at_24_Hours",
            "samples": [
              "AtGen_A-61_35-1_REP1_ATH1",
              "AtGen_A-62_35-2_REP2_ATH1",
              "AtGen_A-64_35-4_REP3_ATH1"
            ]
          },
          {
            "name": "Virulent Pseudomonas syringae at 24 Hours",
            "id": "Virulent_Pseudomonas_syringae_at_24_Hours",
            "samples": [
              "AtGen_A-13_23-1_REP1_ATH1",
              "AtGen_A-14_23-2_REP2_ATH1",
              "AtGen_A-16_23-4_REP3_ATH1"
            ]
          },
          {
            "name": "Avirulent Pseudomonas syringae at 24 Hours",
            "id": "Avirulent_Pseudomonas_syringae_at_24_Hours",
            "samples": [
              "AtGen_A-25_26-1_REP1_ATH1",
              "AtGen_A-26_26-2_REP2_ATH1 ",
              "AtGen_A-28_26-4_REP3_ATH1"
            ]
          },
          {
            "name": "Deficient Pseudomonas syringae at 24 Hours",
            "id": "Deficient_Pseudomonas_syringae_at_24_Hours",
            "samples": [
              "AtGen_A-37_29-1_REP1_ATH1",
              "AtGen_A-38_29-2_REP2_ATH1",
              "AtGen_A-40_29-4_REP3_ATH1"
            ]
          },
          {
            "name": "Nonhost Pseudomonas syringae at 24 Hours",
            "id": "Nonhost_Pseudomonas_syringae_at_24_Hours",
            "samples": [
              "AtGen_A-49_32-1_REP1_ATH1",
              "AtGen_A-50_32-2_REP2_ATH1",
              "AtGen_A-52_32-4_REP3_ATH1"
            ]
          }
        ]
      }
    ]
  },
  "BioticStressGolovinomycesorontiiView": {
    "db": "atgenexp_pathogen",
    "groups": [
      {
        "name": "GSM392490;GSM392491",
        "controls": [
          "GSM392490",
          "GSM392491"
        ],
        "tissues": [
          {
            "name": "Col laser microdissected, 5 d UI,",
            "id": "ColLaserMicrodissected-5dUninfected",
            "samples": [
              "GSM392490",
              "GSM392491"
            ]
          },
          {
            "name": "Col laser microdissected, 5 dpi",
            "id": "ColLaserMicrodissected-5dPostInfected",
            "samples": [
              "GSM392488",
              "GSM392489"
            ]
          },
          {
            "name": "eds16 laser microdissected, 5 dpi",
            "id": "eds16LaserMicrodissected-5dPostInfected",
            "samples": [
              "GSM392492",
              "GSM392493"
            ]
          }
        ]
      },
      {
        "name": "GSM392500;GSM392501",
        "controls": [
          "GSM392500",
          "GSM392501"
        ],
        "tissues": [
          {
            "name": "Col whole leaf amplified, 5 d UI",
            "id": "ColWholeLeafAmplified-5dUninfected",
            "samples": [
              "GSM392500",
              "GSM392501"
            ]
          },
          {
            "name": "Col whole leaf amplified, 5 dpi,",
            "id": "ColWholeLeafAmplified-5dPostInfected",
            "samples": [
              "GSM392498",
              "GSM392499"
            ]
          },
          {
            "name": "Col leaf scrape, 5 dpi",
            "id": "ColLeafScrape-5dPostInfected",
            "samples": [
              "GSM392502",
              "GSM392503"
            ]
          }
        ]
      }
    ]
  },
  "RootImmunityElicitationView": {
    "db": "root_Schaefer_lab",
    "groups": [
      {
        "name": "Epidermis",
        "controls": [
          "WTCHG_203594_01",
          "WTCHG_203594_05",
          "WTCHG_203839_04"
        ],
        "tissues": [
          {
            "name": "Control - Epidermis",
            "id": "Mock-Epidermis",
            "samples": [
              "WTCHG_203594_01",
              "WTCHG_203594_05",
              "WTCHG_203839_04"
            ]
          },
          {
            "name": "flg22 - Epidermis",
            "id": "flg22-Epidermis",
            "samples": [
              "WTCHG_203594_03",
              "WTCHG_203594_07",
              "WTCHG_203839_06"
            ]
          },
          {
            "name": "Pep1 - Epidermis",
            "id": "Pep1-Epidermis",
            "samples": [
              "WTCHG_203839_01",
              "WTCHG_203594_10",
              "WTCHG_203839_08"
            ]
          }
        ]
      },
      {
        "name": "Cortex",
        "controls": [
          "WTCHG_129187_01",
          "WTCHG_129189_01",
          "WTCHG_129190_01"
        ],
        "tissues": [
          {
            "name": "Control - Cortex",
            "id": "Mock-Cortex",
            "samples": [
              "WTCHG_129187_01",
              "WTCHG_129189_01",
              "WTCHG_129190_01"
            ]
          },
          {
            "name": "flg22 - Cortex",
            "id": "flg22-Cortex",
            "samples": [
              "WTCHG_129187_03",
              "WTCHG_129189_03",
              "WTCHG_129190_03"
            ]
          },
          {
            "name": "Pep1 - Cortex",
            "id": "Pep1-Cortex",
            "samples": [
              "WTCHG_129187_05",
              "WTCHG_129189_05",
              "WTCHG_129187_07"
            ]
          }
        ]
      },
      {
        "name": "Pericycle",
        "controls": [
          "WTCHG_131167_01",
          "WTCHG_125416_01",
          "WTCHG_129190_05"
        ],
        "tissues": [
          {
            "name": "Control - Pericycle",
            "id": "Mock-Pericycle",
            "samples": [
              "WTCHG_131167_01",
              "WTCHG_125416_01",
              "WTCHG_129190_05"
            ]
          },
          {
            "name": "flg22 - Pericycle",
            "id": "flg22-Pericycle",
            "samples": [
              "WTCHG_131167_03",
              "WTCHG_125416_03",
              "WTCHG_129190_07"
            ]
          },
          {
            "name": "Pep1 - Pericycle",
            "id": "Pep1-Pericycle",
            "samples": [
              "WTCHG_131167_05",
              "WTCHG_125416_05",
              "WTCHG_129189_07"
            ]
          }
        ]
      }
    ]
  },
  "GerminationView": {
    "db": "germination",
    "groups": [
      {
        "name": "Seed Zero Hours",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Zero Hours",
            "id": "germinationZeroHourFillS",
            "samples": [
              "0h_1",
              "0h_2",
              "0h_3"
            ]
          }
        ]
      },
      {
        "name": "Seed One Hour SL",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "One Hour SL",
            "id": "germinationOneHourFillSL",
            "samples": [
              "1hSL_1",
              "1hSL_2",
              "1hSL_3"
            ]
          }
        ]
      },
      {
        "name": "Seed One Hour S",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "One Hour S",
            "id": "germinationOneHourSFill",
            "samples": [
              "1hS_1",
              "1hS_2",
              "1hS_3"
            ]
          }
        ]
      },
      {
        "name": "Seed Twelve Hours S",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Twelve Hours S",
            "id": "germinationTwelveHourFillS",
            "samples": [
              "12hS_1",
              "12hS_2",
              "12hS_3"
            ]
          }
        ]
      },
      {
        "name": "Seed Twelve Hours SL",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Twelve Hours SL",
            "id": "germinationTwelveHourSL",
            "samples": [
              "12hSL_1",
              "12hSL_2",
              "12hSL_3"
            ]
          }
        ]
      },
      {
        "name": "Seed Fourty Eight Hours S",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Fourty Eight Hours S",
            "id": "germinationFourtyEightHoursFillS",
            "samples": [
              "48hS_1",
              "48hS_2",
              "48hS_3"
            ]
          }
        ]
      },
      {
        "name": "Seed Fourty Eight Hours SL",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Fourty Eight Hours SL",
            "id": "germinationFourtyEightHoursFillTopSL",
            "samples": [
              "48hSL_1",
              "48hSL_2",
              "48hSL_3"
            ]
          },
          {
            "name": "Fourty Eight Hours SL",
            "id": "germinationFourtyEightHoursFillSL",
            "samples": [
              "48hSL_1",
              "48hSL_2",
              "48hSL_3"
            ]
          },
          {
            "name": "Fourty Eight Hours SL",
            "id": "germinationFourtyEightHoursFillTopSmallBitsSL",
            "samples": [
              "48hSL_1",
              "48hSL_2",
              "48hSL_3"
            ]
          }
        ]
      },
      {
        "name": "Harvest",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Harvest",
            "id": "germinationHFill",
            "samples": [
              "harvest_1",
              "harvest_2",
              "harvest_3"
            ]
          }
        ]
      },
      {
        "name": "Seed Six Hours",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Six Hours SL",
            "id": "germinationSixHourSLFill",
            "samples": [
              "6hSL_1",
              "6hSL_2",
              "6hSL_3"
            ]
          }
        ]
      },
      {
        "name": "Seed Twenty Four Hours",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Twenty Four SL",
            "id": "germinationTwentyFourHourFillSL",
            "samples": [
              "24hSL_1",
              "24hSL_2",
              "24hSL_3"
            ]
          }
        ]
      }
    ]
  },
  "ShootApexView": {
    "db": "shoot_apex",
    "groups": [
      {
        "name": "ShootApexGroup",
        "controls": [
          "AVG"
        ],
        "tissues": [
          {
            "name": "ATML1",
            "id": "ATML1",
            "samples": [
              "ATML1"
            ]
          },
          {
            "name": "FIL",
            "id": "FIL",
            "samples": [
              "FIL"
            ]
          },
          {
            "name": "PTL",
            "id": "PTL",
            "samples": [
              "PTL"
            ]
          },
          {
            "name": "AS2",
            "id": "AS2",
            "samples": [
              "AS2"
            ]
          },
          {
            "name": "WUS",
            "id": "WUS",
            "samples": [
              "WUS"
            ]
          },
          {
            "name": "CLV3",
            "id": "CLV3",
            "samples": [
              "CLV3"
            ]
          },
          {
            "name": "UFO",
            "id": "UFO",
            "samples": [
              "UFO"
            ]
          },
          {
            "name": "LAS",
            "id": "LAS",
            "samples": [
              "LAS"
            ]
          }
        ]
      }
    ]
  },
  "SingleCellView": {
    "db": "single_cell",
    "groups": [
      {
        "name": "Med_CTRL",
        "controls": [
          "Med_CTRL"
        ],
        "tissues": [
          {
            "name": "Stele cells (6)",
            "id": "SteleG0-SteleCells6",
            "samples": [
              "cluster6_WT1.ExprMean",
              "cluster6_WT2.ExprMean",
              "cluster6_WT3.ExprMean"
            ]
          },
          {
            "name": "Differentiating non-hair epidermal cells (1)",
            "id": "EpidermisNG3-DifferentiatingNonHairEpidermalCells1",
            "samples": [
              "cluster1_WT1.ExprMean",
              "cluster1_WT2.ExprMean",
              "cluster1_WT3.ExprMean"
            ]
          },
          {
            "name": "Endodermis cells (12)",
            "id": "EndodermisG7-EndodermisCells12",
            "samples": [
              "cluster12_WT1.ExprMean",
              "cluster12_WT2.ExprMean",
              "cluster12_WT3.ExprMean"
            ]
          },
          {
            "name": "Stele cells (18)",
            "id": "SteleG5-SteleCells18",
            "samples": [
              "cluster18_WT1.ExprMean",
              "cluster18_WT2.ExprMean",
              "cluster18_WT3.ExprMean"
            ]
          },
          {
            "name": "Stele cells (including pericyte) (7)",
            "id": "SteleG0-SteleCellsIncludingPericyte7",
            "samples": [
              "cluster7_WT1.ExprMean",
              "cluster7_WT2.ExprMean",
              "cluster7_WT3.ExprMean"
            ]
          },
          {
            "name": "Mid-stage differentiating root hair epidermal cells (4)",
            "id": "EpidermisHG4-MidStageDifferentiatingRootHairEpidermalCells4",
            "samples": [
              "cluster4_WT1.ExprMean",
              "cluster4_WT2.ExprMean",
              "cluster4_WT3.ExprMean"
            ]
          },
          {
            "name": "Dividing meristem cell (25)",
            "id": "RootCapG1-DividingMeristemCells25",
            "samples": [
              "cluster25_WT1.ExprMean",
              "cluster25_WT2.ExprMean",
              "cluster25_WT3.ExprMean"
            ]
          },
          {
            "name": "Late-stage differentiating root hair epidermal cells (3)",
            "id": "EpidermisHG4-LateStageDifferentiatingRootHairEpidermalCells3",
            "samples": [
              "cluster3_WT1.ExprMean",
              "cluster3_WT2.ExprMean",
              "cluster3_WT3.ExprMean"
            ]
          },
          {
            "name": "Stele cells (including pericyte) (14)",
            "id": "SteleG0-SteleCellsIncludingPericyte14",
            "samples": [
              "cluster14_WT1.ExprMean",
              "cluster14_WT2.ExprMean",
              "cluster14_WT3.ExprMean"
            ]
          },
          {
            "name": "Cortex cells (31)",
            "id": "CortexG6-CortexCells31",
            "samples": [
              "cluster31_WT1.ExprMean",
              "cluster31_WT2.ExprMean",
              "cluster31_WT3.ExprMean"
            ]
          },
          {
            "name": "Stele cells (20)",
            "id": "SteleG0-SteleCells20",
            "samples": [
              "cluster20_WT1.ExprMean",
              "cluster20_WT2.ExprMean",
              "cluster20_WT3.ExprMean"
            ]
          },
          {
            "name": "Differentiating endodermis/cortex cells (30)",
            "id": "CortexG6-DifferentiatingEndodermisCortexCells30",
            "samples": [
              "cluster30_WT1.ExprMean",
              "cluster30_WT2.ExprMean",
              "cluster30_WT3.ExprMean"
            ]
          },
          {
            "name": "Phloem cells (21)",
            "id": "SteleCellsG0-PhloemCells21",
            "samples": [
              "cluster21_WT1.ExprMean",
              "cluster21_WT2.ExprMean",
              "cluster21_WT3.ExprMean"
            ]
          },
          {
            "name": "Lateral root cap cells (2)",
            "id": "RootCapG1-LateralRootCapCells2",
            "samples": [
              "cluster2_WT1.ExprMean",
              "cluster2_WT2.ExprMean",
              "cluster2_WT3.ExprMean"
            ]
          },
          {
            "name": "Quiescent center cells and young meristem cells (17)",
            "id": "RootCapG1-QuiescentCenterCellsAndYoungMeristemCells17",
            "samples": [
              "cluster17_WT1.ExprMean",
              "cluster17_WT2.ExprMean",
              "cluster17_WT3.ExprMean"
            ]
          },
          {
            "name": "Root hair epidermal cells (10)",
            "id": "EpidermisHG8-RootHairEpidermalCells10",
            "samples": [
              "cluster10_WT1.ExprMean",
              "cluster10_WT2.ExprMean",
              "cluster10_WT3.ExprMean"
            ]
          },
          {
            "name": "Non-hair epidermal cells (16)",
            "id": "EpidermisNG3-NonHairEpidermalCells16",
            "samples": [
              "cluster16_WT1.ExprMean",
              "cluster16_WT2.ExprMean",
              "cluster16_WT3.ExprMean"
            ]
          },
          {
            "name": "Early-stage differentiating root hair epidermal cells (5)",
            "id": "EpidermisNG3-EarlyStageDifferentiatingRootHairEpidermalCells5",
            "samples": [
              "cluster5_WT1.ExprMean",
              "cluster5_WT2.ExprMean",
              "cluster5_WT3.ExprMean"
            ]
          },
          {
            "name": "Differentiating lateral root cap cells (8)",
            "id": "RootCapG1-DifferentiatingRootCapCells8",
            "samples": [
              "cluster8_WT1.ExprMean",
              "cluster8_WT2.ExprMean",
              "cluster8_WT3.ExprMean"
            ]
          },
          {
            "name": "Stele cells (34)",
            "id": "SteleG0-SteleCells34",
            "samples": [
              "cluster34_WT1.ExprMean",
              "cluster34_WT2.ExprMean",
              "cluster34_WT3.ExprMean"
            ]
          },
          {
            "name": "Root hair epidermal cells (26)",
            "id": "EpidermisHG8-RootHairEpidermalCells26",
            "samples": [
              "cluster26_WT1.ExprMean",
              "cluster26_WT2.ExprMean",
              "cluster26_WT3.ExprMean"
            ]
          },
          {
            "name": "Cortex cells (11)",
            "id": "CortexG6-CortexCells11",
            "samples": [
              "cluster11_WT1.ExprMean",
              "cluster11_WT2.ExprMean",
              "cluster11_WT3.ExprMean"
            ]
          },
          {
            "name": "Differentiating endodermis/cortex cells (0)",
            "id": "EndocortexG2-DifferentiatingEndodermisCortexCells0",
            "samples": [
              "cluster0_WT1.ExprMean",
              "cluster0_WT2.ExprMean",
              "cluster0_WT3.ExprMean"
            ]
          },
          {
            "name": "Columella root cap cells (28)",
            "id": "RootCapG1-ColumellaRootCapCells28",
            "samples": [
              "cluster28_WT1.ExprMean",
              "cluster28_WT2.ExprMean",
              "cluster28_WT3.ExprMean"
            ]
          },
          {
            "name": "Stele cells (9)",
            "id": "SteleG5-SteleCells9",
            "samples": [
              "cluster9_WT1.ExprMean",
              "cluster9_WT2.ExprMean",
              "cluster9_WT3.ExprMean"
            ]
          },
          {
            "name": "Xylem cells (27)",
            "id": "SteleG5-XylemCells27",
            "samples": [
              "cluster27_WT1.ExprMean",
              "cluster27_WT2.ExprMean",
              "cluster27_WT3.ExprMean"
            ]
          },
          {
            "name": "Early-stage differentiating endodermis/cortex cells",
            "id": "EndocortexG2-EarlyStageDifferentiatingEndodermisCortexCells13",
            "samples": [
              "cluster13_WT1.ExprMean",
              "cluster13_WT2.ExprMean",
              "cluster13_WT3.ExprMean"
            ]
          },
          {
            "name": "Xylem cells (23)",
            "id": "SteleG5-XylemCells23",
            "samples": [
              "cluster23_WT1.ExprMean",
              "cluster23_WT2.ExprMean",
              "cluster23_WT3.ExprMean"
            ]
          },
          {
            "name": "Early-stage differentiating endodermis/cortex cells (35)",
            "id": "EndocortexG2-EarlyStageDifferentiatingEndodermisCortexCells35",
            "samples": [
              "cluster35_WT1.ExprMean",
              "cluster35_WT2.ExprMean",
              "cluster35_WT3.ExprMean"
            ]
          },
          {
            "name": "Early-stage differentiating root hair epidermal cells (15)",
            "id": "EpidermisHG4-EarlyStageDifferentiatingRootHairEpidermalCells15",
            "samples": [
              "cluster15_WT1.ExprMean",
              "cluster15_WT2.ExprMean",
              "cluster15_WT3.ExprMean"
            ]
          },
          {
            "name": "Cortex cells (19)",
            "id": "CortexG6-CortexCells19",
            "samples": [
              "cluster19_WT1.ExprMean",
              "cluster19_WT2.ExprMean",
              "cluster19_WT3.ExprMean"
            ]
          },
          {
            "name": "Dividing meristem cells (24)",
            "id": "RootCapG1-DividingMeristemCells24",
            "samples": [
              "cluster24_WT1.ExprMean",
              "cluster24_WT2.ExprMean",
              "cluster24_WT3.ExprMean"
            ]
          },
          {
            "name": "Differentiating endodermis/cortex cells (29)",
            "id": "EndocortexG2-DifferentiatingEndodermisCortexCells29",
            "samples": [
              "cluster29_WT1.ExprMean",
              "cluster29_WT2.ExprMean",
              "cluster29_WT3.ExprMean"
            ]
          },
          {
            "name": "Dividing meristem cells (32)",
            "id": "EndocortexG2-DividingMeristemCells32",
            "samples": [
              "cluster32_WT1.ExprMean",
              "cluster32_WT2.ExprMean",
              "cluster32_WT3.ExprMean"
            ]
          },
          {
            "name": "Protoxylem cells (33)",
            "id": "SteleG5-ProtoxylemCells33",
            "samples": [
              "cluster33_WT1.ExprMean",
              "cluster33_WT2.ExprMean",
              "cluster33_WT3.ExprMean"
            ]
          },
          {
            "name": "Endodermis cells (22)",
            "id": "EndodermisG7-EndodermisCells22",
            "samples": [
              "cluster22_WT1.ExprMean",
              "cluster22_WT2.ExprMean",
              "cluster22_WT3.ExprMean"
            ]
          }
        ]
      }
    ]
  }
}
''')

# ---------------------------------------------------------------------------
# Core logic
# ---------------------------------------------------------------------------


def _fetch_samples(db: str, gene: str, names: list) -> list:
    """Query plantefp.cgi for a chunk of sample names; return [{name, value}]."""
    url = (
        f"{PLANTEFP_BASE}?datasource={db}"
        f"&id={gene}"
        f"&samples={urllib.parse.quote(json.dumps(names))}"
    )
    try:
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req, timeout=30, context=_SSL_CTX) as r:
            data = json.loads(r.read())
        return [
            {"name": row["name"], "value": float(row["value"])}
            for row in data
            if row and "value" in row and row["value"] not in (None, "", "null")
            and _is_finite(row["value"])
        ]
    except Exception:
        return []


def _is_finite(v) -> bool:
    try:
        f = float(v)
        return f == f and f not in (float("inf"), float("-inf"))
    except (TypeError, ValueError):
        return False


def _collect_samples_by_db(views: dict) -> dict:
    """Return {db: set(all sample + control names for that db)}."""
    by_db = defaultdict(set)
    for vid, v in views.items():
        db = v["db"]
        for g in v["groups"]:
            for c in g["controls"]:
                if c:
                    by_db[db].add(c)
            for t in g["tissues"]:
                for s in t["samples"]:
                    if s:
                        by_db[db].add(s)
    return {db: list(names) for db, names in by_db.items()}


def get_expression(gene: str) -> dict:
    """
    Fetch expression for all Arabidopsis ePlant views for a single gene.

    Returns the full XML structure merged with resolved expression values so
    the caller needs no separate XML fetches or per-view CGI calls.

    Response shape:
        {
          "gene": "AT1G01010",
          "views": {
            "<viewId>": {
              "groups": [
                {
                  "name": "<groupName>",
                  "controls": { "<sampleName>": <float>, ... },
                  "tissues": [
                    {
                      "name": "<tissueName>",
                      "id": "<tissueId>",
                      "samples": { "<sampleName>": <float>, ... }
                    }
                  ]
                }
              ]
            }
          }
        }
    """
    samples_by_db = _collect_samples_by_db(VIEWS)

    # Fan out all CGI requests in parallel, grouped by database
    tasks = []
    for db, names in samples_by_db.items():
        chunks = [names[i:i + CHUNK_SIZE] for i in range(0, len(names), CHUNK_SIZE)]
        for chunk in chunks:
            tasks.append((db, chunk))

    db_results: dict[str, dict[str, float]] = defaultdict(dict)
    with ThreadPoolExecutor(max_workers=20) as pool:
        futures = {
            pool.submit(_fetch_samples, db, gene, chunk): db
            for db, chunk in tasks
        }
        for future in as_completed(futures):
            db = futures[future]
            for row in future.result():
                db_results[db][row["name"]] = row["value"]

    # Merge XML structure with resolved values
    view_results = {}
    for vid, v in VIEWS.items():
        resolved = db_results.get(v["db"], {})
        groups = []
        for g in v["groups"]:
            groups.append({
                "name": g["name"],
                "controls": {
                    c: resolved[c]
                    for c in g["controls"]
                    if c and c in resolved
                },
                "tissues": [
                    {
                        "name": t["name"],
                        "id": t["id"],
                        "samples": {
                            s: resolved[s]
                            for s in t["samples"]
                            if s and s in resolved
                        },
                    }
                    for t in g["tissues"]
                ],
            })
        view_results[vid] = {"groups": groups}

    return {"gene": gene, "views": view_results}


# ---------------------------------------------------------------------------
# Entry points
# ---------------------------------------------------------------------------

def _run_cgi():
    import cgi
    import cgitb
    cgitb.enable()
    form = cgi.FieldStorage()
    gene = form.getvalue("gene", "").strip().upper()
    species = form.getvalue("species", "Arabidopsis").strip()

    print("Content-Type: application/json")
    print("Access-Control-Allow-Origin: *")
    print()

    if not gene:
        print(json.dumps({"error": "Missing required parameter: gene"}))
        return

    if species.lower() not in ("arabidopsis", "arabidopsis thaliana"):
        print(json.dumps({"error": f"Unsupported species: {species}"}))
        return

    print(json.dumps(get_expression(gene)))


def _run_cli():
    gene = sys.argv[1].strip().upper() if len(sys.argv) > 1 else "AT1G01010"
    result = get_expression(gene)
    print(f"Gene: {result['gene']}")
    for vid, view in result["views"].items():
        total_samples = sum(len(t["samples"]) for g in view["groups"] for t in g["tissues"])
        total_controls = sum(len(g["controls"]) for g in view["groups"])
        print(f"  {vid}: {len(view['groups'])} groups, {total_samples} tissue samples, {total_controls} controls resolved")


if __name__ == "__main__":
    if os.environ.get("REQUEST_METHOD"):
        _run_cgi()
    else:
        _run_cli()
