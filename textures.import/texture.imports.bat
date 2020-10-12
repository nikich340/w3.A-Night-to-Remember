::
:: will be called at texture import step
::
@echo off
:: ---------------------------------------------------
:: --- check for settings
:: ---------------------------------------------------
IF %SETTINGS_LOADED% EQU 1 goto :SettingsLoaded

echo ERROR! Settings not loaded! - do not start this file directly!
EXIT /B 1

:SettingsLoaded

:: ---------------------------------------------------
:: add one line for every texture to import
::
:: %BIN_IMPORT_TEXTURE% <srcimage> <targetpath>.xbm <optional texturegroup>
::
:: e.g.:
::  %BIN_IMPORT_TEXTURE% data/entities/meshes/ciri_hw_clumping.png data/entities/meshes/ciri_hw_clumping.xbm

:: dlc/dlcntr/data/fx/orianna_smoke/smoke_front_animated02_ver2.xbm
:: dlc/dlcntr/data/entities/oriana/model/eye_d03.xbm

:: NTR LOGO
%BIN_IMPORT_TEXTURE% data/gameplay/logos/ntr_logo_en.png data/gameplay/logos/ntr_logo_en.xbm WorldDiffuseWithAlpha

	:: Bruxa morph torso
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/t_02__bruxa_bloody_d01.tga data/entities/oriana/model/bruxa/t_02__bruxa_bloody_d01.xbm CharacterDiffuse
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/t_02__bruxa_bloody_a01.tga data/entities/oriana/model/bruxa/t_02__bruxa_bloody_a01.xbm CharacterDiffuse

	:: Human bloody2 for bruxa
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/oriana_bruxa_human_bloody2_a01.tga data/entities/oriana/model/bruxa/oriana_bruxa_human_bloody2_a01.xbm CharacterDiffuse
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/oriana_bruxa_human_bloody2_d01.tga data/entities/oriana/model/bruxa/oriana_bruxa_human_bloody2_d01.xbm CharacterDiffuse

	:: Bruxa normal for bruxa (+n for bloody2, +a for vampire_bloody)
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/oriana_bruxa_monster_a01.tga data/entities/oriana/model/bruxa/oriana_bruxa_monster_a01.xbm CharacterDiffuse
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/oriana_bruxa_monster_d01.tga data/entities/oriana/model/bruxa/oriana_bruxa_monster_d01.xbm CharacterDiffuse
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/oriana_bruxa_monster_n01.tga data/entities/oriana/model/bruxa/oriana_bruxa_monster_n01.xbm NormalmapGloss

	:: Bruxa bloody2 for bruxa
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/oriana_bruxa_monster_bloody2_a01.tga data/entities/oriana/model/bruxa/oriana_bruxa_monster_bloody2_a01.xbm CharacterDiffuse
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/bruxa/oriana_bruxa_monster_bloody2_d01.tga data/entities/oriana/model/bruxa/oriana_bruxa_monster_bloody2_d01.xbm CharacterDiffuse

  :::: Orianna vampire clean
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/oriana_vampire_clean_d01.tga data/entities/oriana/model/oriana_vampire_clean_d01.xbm CharacterDiffuse
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/oriana_vampire_clean_n01.tga data/entities/oriana/model/oriana_vampire_clean_n01.xbm NormalmapGloss
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/oriana_vampire_clean_a01.tga data/entities/oriana/model/oriana_vampire_clean_a01.xbm CharacterDiffuse

  :::: Orianna human bloody
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/oriana_human_bloody_d01.tga data/entities/oriana/model/oriana_human_bloody_d01.xbm CharacterDiffuse
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/oriana_human_bloody_a01.tga data/entities/oriana/model/oriana_human_bloody_a01.xbm CharacterDiffuse
:: Use vanilla a

  :::: Orianna vampire bloody
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/oriana_vampire_bloody_d01.tga data/entities/oriana/model/oriana_vampire_bloody_d01.xbm CharacterDiffuse
:: Use vampire clean clean n
:: Use bruxa monster a

  :: Orianna stuff
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/orianna_dress_d03.png data/entities/oriana/model/orianna_dress_d03.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/orianna_dress_n03.png data/entities/oriana/model/orianna_dress_n03.xbm NormalmapGloss
%BIN_IMPORT_TEXTURE% data/entities/oriana/model/eye_d03.tga data/entities/oriana/model/eye_d03.xbm WorldDiffuse

%BIN_IMPORT_TEXTURE% data/fx/orianna_smoke/water_bubble_no_alpha.tga data/fx/orianna_smoke/water_bubble_no_alpha.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data/fx/orianna_smoke/smoke_front_animated02_ver2.tga data/fx/orianna_smoke/smoke_front_animated02_ver2.xbm WorldDiffuseWithAlpha

:: w1 prol
%BIN_IMPORT_TEXTURE% data_w1_prol/entities/models/azar/cr_rienc1_c1_d.tga data_w1_prol/entities/models/azar/cr_rienc1_c1_d.xbm CharacterDiffuseWithAlpha
%BIN_IMPORT_TEXTURE% data_w1_prol/entities/models/azar/cr_rienc1_c1_n.tga data_w1_prol/entities/models/azar/cr_rienc1_c1_n.xbm NormalmapGloss
%BIN_IMPORT_TEXTURE% data_w1_prol/entities/models/azar/h_01_ma__hakland_mage_d01.tga data_w1_prol/entities/models/azar/h_01_ma__hakland_mage_d01.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data_w1_prol/entities/models/azar/h_01_ma__hakland_mage_n01.tga data_w1_prol/entities/models/azar/h_01_ma__hakland_mage_n01.xbm NormalmapGloss
%BIN_IMPORT_TEXTURE% data_w1_prol/entities/models/azar/man_average__d01.tga data_w1_prol/entities/models/azar/man_average__d01.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data_w1_prol/entities/models/azar/man_big__n01.tga data_w1_prol/entities/models/azar/man_big__n01.xbm NormalmapGloss
%BIN_IMPORT_TEXTURE% data_w1_prol/entities/models/savolla/legs_d.tga data_w1_prol/entities/models/savolla/legs_d.xbm WorldDiffuse

:: iorweth
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/model/iorweth__n.tga data/entities/iorwetm/model/iorweth__n.xbm NormalmapGloss
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/model/iorweth__a01.tga data/entities/iorwetm/model/iorweth__a01.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/model/iorweth__d01.tga data/entities/iorwetm/model/iorweth__d01.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/model/iorweth__hair_d01.tga data/entities/iorwetm/model/iorweth__hair_d01.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/model/iorweth__n.tga data/entities/iorwetm/model/roche_b1_n01.xbm NormalmapGloss
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/model/iorweth__a01.tga data/entities/iorwetm/model/roche_b1_a01.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/model/iorweth__d01.tga data/entities/iorwetm/model/roche_b1_d01.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/novigrad_citizen_halfling/c_04_ha__novigrad_citizen_halfling_d01.tga data/entities/iorwetm/novigrad_citizen_halfling/c_04_ha__novigrad_citizen_halfling_d01.xbm WorldDiffuse
%BIN_IMPORT_TEXTURE% data/entities/iorwetm/novigrad_citizen_halfling/c_04_ha__novigrad_citizen_halfling_n01.tga data/entities/iorwetm/novigrad_citizen_halfling/c_04_ha__novigrad_citizen_halfling_n01.xbm NormalmapGloss
:: last parameter can be set to define texturegroup if necessary, like this:
::
:: %BIN_IMPORT_TEXTURE% <srctexture.png> /data/textures/<targetname>.xbm WorldDiffuseWithAlpha
::
:: default texturegroup is: WorldDiffuse
:: Supported texture group names:
::       BillboardAtlas
::       CharacterDiffuse
::       CharacterDiffuseWithAlpha
::       CharacterEmissive
::       CharacterNormal
::       CharacterNormalHQ
::       CharacterNormalmapGloss
::       Default
::       DetailNormalMap
::       DiffuseNoMips
::       Flares
::       FoliageDiffuse
::       Font
::       GUIWithAlpha
::       GUIWithoutAlpha
::       HeadDiffuse
::       HeadDiffuseWithAlpha
::       HeadEmissive
::       HeadNormal
::       HeadNormalHQ
::       MimicDecalsNormal
::       NormalmapGloss
::       NormalsNoMips
::       Particles
::       ParticlesWithoutAlpha
::       PostFxMap
::       QualityColor
::       QualityOneChannel
::       QualityTwoChannels
::       SpecialQuestDiffuse
::       SpecialQuestNormal
::       SystemNoMips
::       TerrainDiffuse
::       TerrainNormal
::       WorldDiffuse
::       WorldDiffuseWithAlpha
::       WorldEmissive
::       WorldNormal
::       WorldNormalHQ
::       WorldSpecular
