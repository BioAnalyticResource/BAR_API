class WorldeFPUtils:
    @staticmethod
    def wrap_json(id, full_sample_id, expr_value, probeset):
        """
        :param msg: message to pass on failure
        :return:
        """
        mapping = {
          "111" : {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Bay-0 (CS6608) from Bayreuth, Germany<br>Longitude/Latitude/Elevation: E11/N50 at ~300m",
            "samples": ["ATGE_111_A", "ATGE_111_B", "ATGE_111_C"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "49.950999", "lng": "11.572323"},
          },
          "112": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "C24 (CS906) from Coimbra, Portugal",
            "samples": ["ATGE_112_A", "ATGE_112_C", "ATGE_112_D"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "40.217684", "lng": "-8.436921"},
          },
          "113": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Col-0 (N1092) from Columbia, Missouri, USA<br>Longitude/Latitude/Elevation: W93/N38 at 1-100m<br>Temp in C (Spr/Aut):15-16/21-2<br>Precipitation in mm (Spr/Aut):60-70/30-40",
            "samples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "38.964748", "lng": "-92.335396"},
          },
          "114": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Cvi-1 (CS8580) from Cape Verde Islands<br>Longitude/Latitude/Elevation: W24/N16 at 1-100m",
            "samples": ["ATGE_114_A", "ATGE_114_B", "ATGE_114_C"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "16.24632", "lng": "-23.963013"},
          },
          "115": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Est (CS6173) from Estonia<br>Longitude/Latitude/Elevation: E25/N59 at 100-200m",
            "samples": ["ATGE_115_A", "ATGE_115_B", "ATGE_115_D"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "59.00097", "lng": "25.651245"},
          },
          "116": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Kin-0 (CS6755) from Kendallville, Indiana, USA<br>Longitude/Latitude/Elevation: W85/N43 at 200-300m",
            "samples": ["ATGE_116_A", "ATGE_116_B", "ATGE_116_C"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "41.446329", "lng": "-85.26495"},
          },
          "117": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Ler-2 (CS8581) from Landsberg, Germany<br>Longitude/Latitude/Elevation: E15/N53 at 100-200m",
            "samples": ["ATGE_117_B", "ATGE_117_C", "ATGE_117_D"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "48.056283", "lng": "10.870914"},
          },
          "118": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Nd-1 (CS1636) from Niederzell, Germany<br>Longitude/Latitude/Elevation: at 200-300m<br>Temp in C (Spr/Aut):5-6/9-10<br>Precipitation in mm (Spr/Aut):20-30/30-40",
            "samples": ["ATGE_118_A", "ATGE_118_B", "ATGE_118_C"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "50.329382", "lng": "9.506686"},
          },
          "119": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Sha (CS6180) from Pamiro-Alay, Kyrgyzstan<br>Longitude/Latitude/Elevation: E71/N39 at 3400m",
            "samples": ["ATGE_119_A", "ATGE_119_C", "ATGE_119_D"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "39.557001", "lng": "71.006927"},
          },
          "120": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803961",
            "id": "Van-0 (CS6884) from Vancouver, BC., Canada<br>Longitude/Latitude/Elevation: W123/N49 at 1-100m<br>Temp in C (Spr/Aut):2-9/10-18",
            "samples": ["ATGE_120_A", "ATGE_120_B", "ATGE_120_C"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "49.266236", "lng": "-123.113537"},
          },
          "121": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Ak-1 (CS6602) from Achkarren, Germany<br>Longitude/Latitude/Elevation: E8/N48 at 200m<br>Temp in C (Spr/Aut):7-8/11-12<br>Precipitation in mm (Spr/Aut):50-60/50-60",
            "samples": ["ATGE_121_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "48.068788", "lng": "7.626436"},
          },
          "124": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Bla-5 (CS6620) from Blanes, Spain<br>Longitude/Latitude/Elevation: E3/N41 at 50m<br>Temp in C (Spr/Aut):17-18/11-12<br>Precipitation in mm (Spr/Aut):40-50/40-50",
            "samples": ["ATGE_124_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "41.677464", "lng": "2.790427"},
          },
          "125": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Can-0 (CS6660) from Canary Islands, Spain<br>Longitude/Latitude/Elevation: W15/N28 at 1260m",
            "samples": ["ATGE_125_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "28.545926", "lng": "-16.602173"},
          },
          "126": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Cen-0 (CS6661) from Caen, France<br>Longitude/Latitude/Elevation: W0/N49 at 1-100m",
            "samples": ["ATGE_126_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "49.185182", "lng": "-0.370646"},
          },
          "127": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "CIBC10 (CS22229) from Ascot, United Kingdom",
            "samples": ["ATGE_127_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "51.407505", "lng": "-0.675923"},
          },
          "128": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Dra-1 (CS6686) from Drahonin, Czech Republic<br>Longitude/Latitude/Elevation: E16/N49 at 450m",
            "samples": ["ATGE_128_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "49.415217", "lng": "16.276488"},
          },
          "129": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "En-T (CS6176) from Tadjikistan",
            "samples": ["ATGE_129_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "38.899583", "lng": "68.773498"},
          },
          "130": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Er-0 (CS6698) from Erlangen, Germany<br>Longitude/Latitude/Elevation: E11/N49 at 200-300m<br>Temp in C (Spr/Aut):5-6/9-10<br>Precipitation in mm (Spr/Aut):30-40/30-40",
            "samples": ["ATGE_130_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "49.597583", "lng": "11.013737"},
          },
          "131": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Fr-2 (CS6708) from Frankfurt, Germany<br>Longitude/Latitude/Elevation: E8/N50 at 0-100m<br>Temp in C (Spr/Aut):7-8/9-10<br>Precipitation in mm (Spr/Aut):20-30/30-40",
            "samples": ["ATGE_131_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "50.12498", "lng": "8.682518"},
          },
          "132": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "GOT1 (CS22277) from Goettingen, Germany<br>Longitude/Latitude: E10/N51",
            "samples": ["ATGE_132_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "51.545908", "lng": "9.924374"},
          },
          "133": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "HR-5 (CS22205) from Ascot, United Kingdom",
            "samples": ["ATGE_133_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "51.40788", "lng": "-0.670559"},
          },
          "134": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Is-0 (CS6741) from Isenburg, Germany<br>Longitude/Latitude/Elevation: E7/N50 at 100-200m<br>Temp in C (Spr/Aut):7-8/11-12",
            "samples": ["ATGE_134_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "50.4781", "lng": "7.592826"},
          },
          "136": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Li-2:1 (CS6772) from Limburg, Germany<br>Longitude/Latitude/Elevation: E8/N50 at 100-200m<br>Temp in C (Spr/Aut):3-4/9-10<br>Precipitation in mm (Spr/Aut):30-40/30-40",
            "samples": ["ATGE_136_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "50.403922", "lng": "8.082447"},
          },
          "138": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "NFE1 (CS22163) from Ascot, United Kingdom",
            "samples": ["ATGE_138_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "51.409513", "lng": "-0.672637"},
          },
          "139": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Nok-1 (CS6808) from Noordwijk, Netherlands<br>Longitude/Latitude/Elevation: E4/N52 at 0-100m<br>Temp in C (Spr/Aut):3-4/13-14",
            "samples": ["ATGE_139_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "52.24462", "lng": "4.451122"},
          },
          "140": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Nw-1 (CS6812) from Neuweilnau, Germany<br>Longitude/Latitude/Elevation: E8/N50 at 100-200m<br>Temp in C (Spr/Aut):5-6/9-10",
            "samples": ["ATGE_140_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "50.317805", "lng": "8.40782"}
          },
          "141": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "M7323S (CS6184) from Relichova, Czechoslovakia",
            "samples": ["ATGE_141_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "50.094155", "lng": "14.442687"},
          },
          "142": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "MS-0 (CS6797) from Moscow, Russia",
            "samples": ["ATGE_142_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "55.773483", "lng": "37.622452"},
          },
          "144": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Old-2 (CS6821) from Oldenburg, Germany<br>Longitude/Latitude/Elevation: E8/N53 at 1-100m",
            "samples": ["ATGE_144_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "53.1478", "lng": "8.217373"}
          },
          "145": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Ove-0 (CS6823) from Ovelgoenne, Germany<br>Longitude/Latitude/Elevation: E8/N53 at 1-100m<br>Temp in C (Spr/Aut):5-6/9-10",
            "samples": ["ATGE_145_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "53.352601", "lng": "8.421593"}
          },
          "146": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Se-0 (CS6852) from San Eleno, Spain<br>Longitude/Latitude/Elevation: E2/N41 at 0-100m",
            "samples": ["ATGE_146_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "41.386082", "lng": "2.136827"}
          },
          "147": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Sf-2 (CS6857) from San Feliu, Spain<br>Longitude/Latitude/Elevation: E3/N41 at 1-100m<br>Temp in C (Spr/Aut):11-12/19-20",
            "samples": ["ATGE_147_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "41.787313", "lng": "3.031683"}
          },
          "148": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Ta-0 (CS6867) from Tabor, Czech Republic<br>Longitude/Latitude/Elevation: E14/N49 at 400-500m<br>Temp in C (Spr/Aut):3-4/9-10",
            "samples": ["ATGE_148_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "49.417897", "lng": "14.675961"},
          },
          "149": {
            "source": "http://www.arabidopsis.org/servlets/TairObject?type=bio_sample_collection&id=1008803992",
            "id": "Uk-3 (CS6880) from Umkirch, Germany<br>Longitude/Latitude/Elevation: E7/N48 at 200-300m<br>Temp in C (Spr/Aut):7-8/11-12",
            "samples": ["ATGE_149_A"],
            "ctrlSamples": ["ATGE_113_A", "ATGE_113_C", "ATGE_113_D"],
            "position": {"lat": "48.035626", "lng": "7.764058"},
          },
        }
        final_wrap = mapping[id]
        final_wrap.update({
          "probeset" : probeset,
          "values" : {full_sample_id : expr_value},
          "code" : id,
        })
        return final_wrap
