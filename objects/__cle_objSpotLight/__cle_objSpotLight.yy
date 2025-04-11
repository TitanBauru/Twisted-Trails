{
  "$GMObject":"",
  "%Name":"__cle_objSpotLight",
  "eventList":[
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
  ],
  "managed":true,
  "name":"__cle_objSpotLight",
  "overriddenProperties":[],
  "parent":{
    "name":"Lights (Parents)",
    "path":"folders/Libs/KazanGames/CrystalLightingEngine/Assets/Objects/Lights (Parents).yy",
  },
  "parentObjectId":{
    "name":"__cle_objLightDynamic",
    "path":"objects/__cle_objLightDynamic/__cle_objLightDynamic.yy",
  },
  "persistent":false,
  "physicsAngularDamping":0.1,
  "physicsDensity":0.5,
  "physicsFriction":0.2,
  "physicsGroup":1,
  "physicsKinematic":false,
  "physicsLinearDamping":0.1,
  "physicsObject":false,
  "physicsRestitution":0.1,
  "physicsSensor":false,
  "physicsShape":1,
  "physicsShapePoints":[],
  "physicsStartAwake":true,
  "properties":[
    {"$GMObjectProperty":"v1","%Name":"shaderType","filters":[],"listItems":[
        "LIGHT_SHADER_BASIC",
        "LIGHT_SHADER_PHONG",
        "LIGHT_SHADER_BRDF",
      ],"multiselect":false,"name":"shaderType","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"LIGHT_SHADER_BASIC","varType":6,},
    {"$GMObjectProperty":"v1","%Name":"color","filters":[],"listItems":[],"multiselect":false,"name":"color","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"$FFFFFFFF","varType":7,},
    {"$GMObjectProperty":"v1","%Name":"intensity","filters":[],"listItems":[],"multiselect":false,"name":"intensity","rangeEnabled":false,"rangeMax":3.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"inner","filters":[],"listItems":[],"multiselect":false,"name":"inner","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"falloff","filters":[],"listItems":[],"multiselect":false,"name":"falloff","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0.5","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"radius","filters":[],"listItems":[],"multiselect":false,"name":"radius","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"64","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"levels","filters":[],"listItems":[],"multiselect":false,"name":"levels","rangeEnabled":true,"rangeMax":65536.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"65536","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"angle","filters":[],"listItems":[],"multiselect":false,"name":"angle","rangeEnabled":true,"rangeMax":360.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"width","filters":[],"listItems":[],"multiselect":false,"name":"width","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"spotFOV","filters":[],"listItems":[],"multiselect":false,"name":"spotFOV","rangeEnabled":true,"rangeMax":180.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"60","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"spotSmoothness","filters":[],"listItems":[],"multiselect":false,"name":"spotSmoothness","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"spotDistance","filters":[],"listItems":[],"multiselect":false,"name":"spotDistance","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"tilt","filters":[],"listItems":[],"multiselect":false,"name":"tilt","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0.95","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"cookieTexture","filters":[],"listItems":[],"multiselect":false,"name":"cookieTexture","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"__crystalGlobal.textureWhite;","varType":4,},
    {"$GMObjectProperty":"v1","%Name":"castShadows","filters":[],"listItems":[],"multiselect":false,"name":"castShadows","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"False","varType":3,},
    {"$GMObjectProperty":"v1","%Name":"selfShadows","filters":[],"listItems":[],"multiselect":false,"name":"selfShadows","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"False","varType":3,},
    {"$GMObjectProperty":"v1","%Name":"shadowShaderType","filters":[],"listItems":[
        "LIGHT_SHADOW_SHADER_BASIC",
        "LIGHT_SHADOW_SHADER_SMOOTH",
      ],"multiselect":false,"name":"shadowShaderType","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"LIGHT_SHADOW_SHADER_SMOOTH","varType":6,},
    {"$GMObjectProperty":"v1","%Name":"shadowPenumbra","filters":[],"listItems":[],"multiselect":false,"name":"shadowPenumbra","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"20","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"shadowUmbra","filters":[],"listItems":[],"multiselect":false,"name":"shadowUmbra","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"shadowScattering","filters":[],"listItems":[],"multiselect":false,"name":"shadowScattering","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"shadowDepthOffset","filters":[],"listItems":[],"multiselect":false,"name":"shadowDepthOffset","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":1,},
    {"$GMObjectProperty":"v1","%Name":"penetration","filters":[],"listItems":[],"multiselect":false,"name":"penetration","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"normalDistance","filters":[],"listItems":[],"multiselect":false,"name":"normalDistance","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"10","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"diffuse","filters":[],"listItems":[],"multiselect":false,"name":"diffuse","rangeEnabled":true,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"specular","filters":[],"listItems":[],"multiselect":false,"name":"specular","rangeEnabled":true,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"reflection","filters":[],"listItems":[],"multiselect":false,"name":"reflection","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0.25","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"litType","filters":[],"listItems":[
        "LIT_ALWAYS",
        "LIT_LESS_EQUAL",
        "LIT_LESS",
        "LIT_GREATER_EQUAL",
        "LIT_GREATER",
        "LIT_NOT_EQUAL",
        "LIT_EQUAL",
      ],"multiselect":false,"name":"litType","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"LIT_LESS_EQUAL","varType":6,},
    {"$GMObjectProperty":"v1","%Name":"shadowLitType","filters":[],"listItems":[
        "LIT_ALWAYS",
        "LIT_LESS_EQUAL",
        "LIT_LESS",
        "LIT_GREATER_EQUAL",
        "LIT_GREATER",
        "LIT_NOT_EQUAL",
        "LIT_EQUAL",
      ],"multiselect":false,"name":"shadowLitType","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"LIT_LESS_EQUAL","varType":6,},
  ],
  "resourceType":"GMObject",
  "resourceVersion":"2.0",
  "solid":false,
  "spriteId":{
    "name":"__cle_sprEditorSpotLight",
    "path":"sprites/__cle_sprEditorSpotLight/__cle_sprEditorSpotLight.yy",
  },
  "spriteMaskId":null,
  "visible":false,
}