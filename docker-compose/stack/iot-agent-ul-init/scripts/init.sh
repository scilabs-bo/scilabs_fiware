#!/bin/sh
IOTA_HOST="http://iot-agent-ul:4061"
CBROKER_URL="http://context-broker:9090"
FIWARE_SERVICE=smartcity
FIWARE_SERVICE_PATH_CLIMATE_QUARTER=/ClimateQuarter
FIWARE_SERVICE_PATH_MINIATURE_HOUSE=/MiniatureHouse
CQHOUSE_KEY=$CLIMATE_QUARTER_API_KEY
MINIATURE_HOUSE_KEY=scilabs_lab_001



echo "Cleaning Services  cqHouse"

## dont fail on error since service might not exist
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/services?resource=/iot/ul&apikey=$CQHOUSE_KEY" \
    -H "Content-Type: application/json" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/services?resource=/iot/ul&apikey=$MINIATURE_HOUSE_KEY" \
    -H "Content-Type: application/json" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"

echo  "\nCleaning Devices"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/cqHouse01" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/cqHouse02" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/cqHouse03" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/cqHouse04" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/cqHouse05" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/cqHouse06" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/cqHouse07" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER"


curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_001" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_002" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_003" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_004" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_005" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_006" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_007" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_008" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_009" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_010" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_011" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_012" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_013" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/model_house_pgen_014" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE"


echo  "\ņCreating config groups for climate quarter"

# use "type": "**Number**" for jsonb in db
curl --fail-with-body --silent -X POST "$IOTA_HOST/iot/services" \
  -H "Content-Type: application/json" \
  -H "fiware-service: $FIWARE_SERVICE" \
  -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER" \
  -d '{
    "services": [
      {
      "apikey": "'"$CQHOUSE_KEY"'",
      "cbroker": "'"$CBROKER_URL"'",
      "entity_type": "climate-quarter-house",
      "resource": "/iot/ul",
      "autoprovision": false,
      "explicitAttrs": true,
      "attributes":
      [
        { "object_id": "hp.r_cop", "name": "heatPumpCoefficientOfPerformance", "type": "Float" },
        { "object_id": "hp.r_prccp", "name": "heatingPumpControlPercentage", "type": "Float" },
        { "object_id": "hp.r_prchsp", "name": "sourcePumpControlPercentage", "type": "Float" },
        { "object_id": "hp.r_prcond", "name": "condensationPressure", "type": "Float" },
        { "object_id": "hp.r_prcteev", "name": "expansionValveOpeningDegree", "type": "Float" },
        { "object_id": "hp.r_prevap", "name": "evaporationPressure", "type": "Float" },
        { "object_id": "hp.r_tempout1", "name": "outsideTemperature1hAverage", "type": "Float" },
        { "object_id": "hp.r_tempsucg", "name": "suctionGasTemperature", "type": "Float" },
        { "object_id": "i_housenum", "name": "houseNumber", "type": "Integer" },
        { "object_id": "logvar.b_5", "name": "reserve5", "type": "Float" },
        { "object_id": "logvar.b_6", "name": "reserve6", "type": "Float" },
        { "object_id": "logvar.b_extwe", "name": "electricHeatingControl", "type": "Integer" },
        { "object_id": "logvar.b_gsiv1", "name": "groundAbsorberValveControl", "type": "Integer" },
        { "object_id": "logvar.b_gsiv2", "name": "solarAbsorberValveControl", "type": "Integer" },
        { "object_id": "logvar.b_v_ww", "name": "hotWaterValveControl", "type": "Integer" },
        { "object_id": "logvar.di_p_5", "name": "powerReserve5", "type": "Float" },
        { "object_id": "logvar.di_p_6", "name": "powerReserve6", "type": "Float" },
        { "object_id": "logvar.di_p_7", "name": "powerReserve7", "type": "Float" },
        { "object_id": "logvar.di_p_8", "name": "powerReserve8", "type": "Float" },
        { "object_id": "logvar.di_p_bat_ac", "name": "batteryPowerAC", "type": "Float" },
        { "object_id": "logvar.di_p_batt_dc", "name": "batteryPowerDC", "type": "Float" },
        { "object_id": "logvar.di_p_batt_pump", "name": "batteryPumpPower", "type": "Float" },
        { "object_id": "logvar.di_p_batt_soc", "name": "batteryStateOfCharge", "type": "Float" },
        { "object_id": "logvar.di_p_batt", "name": "batteryPowerEcoPowerStation", "type": "Float" },
        { "object_id": "logvar.di_p_booster", "name": "ecoPowerBoosterPower", "type": "Float" },
        { "object_id": "logvar.di_p_comp", "name": "powerReserveComp", "type": "Float" },
        { "object_id": "logvar.di_p_eheiz", "name": "electricHeatingPower", "type": "Float" },
        { "object_id": "logvar.di_p_haus", "name": "powerHouseConsumption", "type": "Float" },
        { "object_id": "logvar.di_p_netz", "name": "powerGrid", "type": "Float" },
        { "object_id": "logvar.di_p_netz2", "name": "powerGridReserve2", "type": "Float" },
        { "object_id": "logvar.di_p_pheizung", "name": "heatingPumpPower", "type": "Float" },
        { "object_id": "logvar.di_p_pquelle", "name": "sourcePumpPower", "type": "Float" },
        { "object_id": "logvar.di_p_solar", "name": "powerPV", "type": "Float" },
        { "object_id": "logvar.di_p_tww_ecopac", "name": "ecoPackDrinkingWaterStationPower", "type": "Float" },
        { "object_id": "logvar.di_p_vent", "name": "ventilationPower", "type": "Float" },
        { "object_id": "logvar.di_p_w2", "name": "heatPumpReservePower2", "type": "Float" },
        { "object_id": "logvar.di_p_wp", "name": "heatPumpPower", "type": "Float" },
        { "object_id": "logvar.di_ptherm_hzg", "name": "heatingThermalPower", "type": "Float" },
        { "object_id": "logvar.di_ptherm_wp", "name": "heatPumpThermalPower", "type": "Float" },
        { "object_id": "logvar.di_ptherm_ww", "name": "hotWaterThermalPower", "type": "Float" },
        { "object_id": "logvar.i_2", "name": "reserveI2", "type": "Float" },
        { "object_id": "logvar.i_3", "name": "reserveI3", "type": "Float" },
        { "object_id": "logvar.i_batt_cyc", "name": "batteryChargeCycles", "type": "Integer" },
        { "object_id": "logvar.i_count_start_comp", "name": "compressorStartCount", "type": "Integer" },
        { "object_id": "logvar.r_hm_flow", "name": "heatMeterFlowRate", "type": "Float" },
        { "object_id": "logvar.r_hm_sum", "name": "totalHeatAmount", "type": "Float" },
        { "object_id": "logvar.r_hm_tempa", "name": "heatMeterTemperatureA", "type": "Float" },
        { "object_id": "logvar.r_hm_tempb", "name": "heatMeterTemperatureB", "type": "Float" },
        { "object_id": "logvar.r_hm_tempdiff", "name": "heatMeterTemperatureDifference", "type": "Float" },
        { "object_id": "LogVar.r_HM_Wtherm", "name": "boosterHotWaterThermalPower", "type": "Float" },
        { "object_id": "logvar.r_p_booster", "name": "boosterThermalPower", "type": "Float" },
        { "object_id": "logvar.r_p_pheizung", "name": "heatingPumpThermalPower", "type": "Float" },
        { "object_id": "logvar.r_p_pquelle", "name": "sourcePumpThermalPower", "type": "Float" },
        { "object_id": "logvar.r_p_tww_ecopack", "name": "ecoPackDrinkingWaterThermalPower", "type": "Float" },
        { "object_id": "logvar.r_p_vent", "name": "ventilationThermalPower", "type": "Float" },
        { "object_id": "logvar.r_temp_abl", "name": "ventilationReturnAirTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_aul", "name": "ventilationOutsideAirTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_aussen", "name": "currentOutsideTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_aussen24h", "name": "outsideTemperature24hAverage", "type": "Float" },
        { "object_id": "logvar.r_temp_fol", "name": "ventilationExhaustAirTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_gsigia_ret", "name": "trenchCollectorReturnTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_gsigia", "name": "trenchCollectorSupplyTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_gsisa_ret", "name": "solarAbsorberReturnTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_gsisa", "name": "solarAbsorberSupplyTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_qaus_epb", "name": "ecoPowerBoosterSourceExitTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_qaus", "name": "sourceExitTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_qein_epb", "name": "ecoPowerBoosterSourceEntryTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_qein", "name": "sourceEntryTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_raum", "name": "roomAirTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_rl", "name": "returnTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_rlsoll", "name": "returnTemperatureSetpoint", "type": "Float" },
        { "object_id": "logvar.r_temp_vl", "name": "flowTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_wwist", "name": "currentHotWaterTemperature", "type": "Float" },
        { "object_id": "logvar.r_temp_wwsoll", "name": "hotWaterTemperatureSetpoint", "type": "Float" },
        { "object_id": "logvar.r_temp_zul", "name": "ventilationSupplyAirTemperature", "type": "Float" },
        { "object_id": "logvar.w_5052_do_bm_e1", "name": "heatPumpSwitchingState1", "type": "Integer" },
        { "object_id": "logvar.w_5053_error_e1", "name": "heatPumpErrorE1", "type": "Integer" },
        { "object_id": "logvar.w_5054_inte1", "name": "heatPumpInterruptions", "type": "Integer" },
        { "object_id": "logvar.w_5055_do_bm_e1", "name": "heatPumpSwitchingState1Duplicate", "type": "Integer" }
      ]
    }]
}'

echo  "\nCreating config groups for miniature house"

curl --fail-with-body --silent -X POST "$IOTA_HOST/iot/services" \
  -H "Content-Type: application/json" \
  -H "fiware-service: $FIWARE_SERVICE" \
  -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE" \
  -d '{
    "services": [
      {
      "apikey": "'"$MINIATURE_HOUSE_KEY"'",
      "cbroker": "'"$CBROKER_URL"'",
      "entity_type": "miniature-house",
      "resource": "/iot/ul",
      "autoprovision": true,
      "explicitAttrs": false,
      "attributes":
      [
        { "object_id": "BAT_CAP", "name": "batteryCapacity", "type": "Float", "expression": "batteryCapacity*0.001" },
        { "object_id": "BAT_I", "name": "batteryCurrent", "type": "Float" },
        { "object_id": "BAT_P", "name": "batteryPower", "type": "Float" },
        { "object_id": "BAT_SOC", "name": "batteryChargeLevel", "type": "Float" },
        { "object_id": "BAT_V", "name": "batteryVoltage", "type": "Float", "expression": "batteryVoltage*0.001"},
        { "object_id": "LOAD_I", "name": "loadCurrent", "type": "Float" },
        { "object_id": "LOAD_P", "name": "loadPower", "type": "Float" },
        { "object_id": "LOAD_V", "name": "loadVoltage", "type": "Float", "expression": "loadVoltage*0.001" },
        { "object_id": "SOL_I", "name": "solarModuleCurrent", "type": "Float" },
        { "object_id": "SOL_P", "name": "solarModulePower", "type": "Float" },
        { "object_id": "SOL_V", "name": "solarModuleVoltage", "type": "Float", "expression": "solarModuleVoltage*0.001" },
        { "object_id": "XCH_I", "name": "energyExchangeCurrent", "type": "Float" },
        { "object_id": "XCH_MODE", "name": "energyExchangeMode", "type": "Number" },
        { "object_id": "XCH_P", "name": "energyExchangePower", "type": "Float" },
        { "object_id": "XCH_V", "name": "energyExchangeVoltage", "type": "Float", "expression": "energyExchangeVoltage*0.001" }
      ]
    }
  ]
}'


echo  "\nCreating cqHouse 1-6."

curl --fail-with-body --silent -X POST "$IOTA_HOST/iot/devices" \
  -H "Content-Type: application/json" \
  -H "fiware-service: $FIWARE_SERVICE" \
  -H "fiware-servicepath: $FIWARE_SERVICE_PATH_CLIMATE_QUARTER" \
  -d '{
        "devices": [
          {
            "device_id": "cqHouse01",
            "entity_name": "urn:ngsi-ld:climate-quarter-house:cqHouse01",
            "entity_type": "climate-quarter-house",
            "apikey": "'"$CQHOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Klimaviertel Haus 1"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "cqHouse02",
            "entity_name": "urn:ngsi-ld:climate-quarter-house:cqHouse02",
            "entity_type": "climate-quarter-house",
            "apikey": "'"$CQHOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Klimaviertel Haus 2"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "cqHouse03",
            "entity_name": "urn:ngsi-ld:climate-quarter-house:cqHouse03",
            "entity_type": "climate-quarter-house",
            "apikey": "'"$CQHOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Klimaviertel Haus 3"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "cqHouse04",
            "entity_name": "urn:ngsi-ld:climate-quarter-house:cqHouse04",
            "entity_type": "climate-quarter-house",
            "apikey": "'"$CQHOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Klimaviertel Haus 4"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "cqHouse05",
            "entity_name": "urn:ngsi-ld:climate-quarter-house:cqHouse05",
            "entity_type": "climate-quarter-house",
            "apikey": "'"$CQHOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Klimaviertel Haus 5"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "cqHouse06",
            "entity_name": "urn:ngsi-ld:climate-quarter-house:cqHouse06",
            "entity_type": "climate-quarter-house",
            "apikey": "'"$CQHOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Klimaviertel Haus 6"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "cqHouse07",
            "entity_name": "urn:ngsi-ld:climate-quarter-house:cqHouse07",
            "entity_type": "climate-quarter-house",
            "apikey": "'"$CQHOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Klimaviertel Haus 7"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
           }
        ]
      }'


echo  "\nCreating model_house_pgen_001."

curl --fail-with-body --silent -X POST "$IOTA_HOST/iot/devices" \
  -H "Content-Type: application/json" \
  -H "fiware-service: $FIWARE_SERVICE" \
  -H "fiware-servicepath: $FIWARE_SERVICE_PATH_MINIATURE_HOUSE" \
  -d '{
        "devices": [
          {
            "device_id": "model_house_pgen_001",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_001",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 1"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_002",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_002",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 2"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_003",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_003",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 3"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_004",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_004",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 4"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_005",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_005",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 5"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_006",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_006",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 6"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_007",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_007",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 7"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_008",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_008",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 8"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_009",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_009",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 9"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_010",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_010",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 10"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_011",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_011",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 11"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_012",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_012",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 12"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "false"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_013",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_013",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 13"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "true"
                }
            ]
          },
          {
            "device_id": "model_house_pgen_014",
            "entity_name": "urn:ngsi-ld:miniature-house:model_house_pgen_014",
            "entity_type": "miniature-house",
            "apikey": "'"$MINIATURE_HOUSE_KEY"'",
            "transport": "MQTT",
            "timezone": "Europe/Berlin",
            "attributes": [],
            "static_attributes": [
                {
                    "name": "name",
                    "type": "Property",
                    "value": "Modelhaus Haus 14"
                },
                {
                    "name": "inactive",
                    "type": "Property",
                    "value": "true"
                }
            ]
          }            
        ]
    }'