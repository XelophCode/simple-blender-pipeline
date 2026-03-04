<img width="2000" height="366" alt="final1" src="https://github.com/user-attachments/assets/4123fbdc-b8c7-4c84-917e-2c9cbebffeea" />

## Table of Contents
[__What is the Simple Blender Pipeline?__](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#what-is-the-simple-blender-pipeline)

[__Features__](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#features)
>[Recomposition](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#recomposition)<br>
>[Material Management](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#material-management)<br>
>[Collision Shape Generation](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#collision-shape-generation)<br>
>[Blender Options](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#blender-options)<br>
>[Misc Fixes](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#misc-fixes)

[Installation](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#installation)
>[Installing the Godot Addon](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#installing-the-godot-addon)<br>
>[Installing the Blender Addon](https://github.com/XelophCode/simple-blender-pipeline?tab=readme-ov-file#installing-the-blender-addon)



## What is the Simple Blender Pipeline?

The Simple Blender Pipeline is an addon for both Blender and Godot that aims to make using .blend files in Godot easier. It leverages Godot's node structure to allow the user to easily recompose the objects of a .blend file after importing it into Godot. The addon also aims to resolve some long standing issues with the default import pipeline. This addon is not a "kitchen sink" addon, it only focuses on what I think are the most pressing issues when working with .blend files. My main focus is for the addon to be lightweight and intuitive to use.

## Features

### Recomposition:
* Automatic unpacking of .blend files when dragging its .tscn file into an open scene.
* SBP will take each individual object in the .blend file and add it to the current scene as it's own MeshInstance3D.
* You can then reorganize each of these MeshInstances as you see fit in your scene tree.
* If you make changes to the .blend file, your scene tree structure in Godot will be maintained.

https://github.com/user-attachments/assets/3e0f62eb-78f9-436e-9ef0-8852713d1af8

### Material Management:
* In Project Settings, you can define default material settings for imported materials.
* These project settings can be overridden via the blender addon if you need a specific material to have unique settings.

https://github.com/user-attachments/assets/12de0909-5681-47f7-a639-e895574be7cc

### Collision Shape Generation:
* Mesh objects can be tagged to auto generate CollisionShape3Ds on import.
* These CollisionShape3Ds can be recomposed just like the MeshInstance3Ds, This allows you to easily set up physics bodies in your scene tree and have your scene tree structure be respected if you make changes to the blend file.
* You can discard the mesh object if you only want the CollisionShape3D.
* The debug visuals in the Godot editor can be automatically hidden on import, this is useful for when you don't want your level geometry to be covered in a z-fighting blue mesh while working.

https://github.com/user-attachments/assets/b3db78fb-8991-4b13-a5ab-549476b6214b

### Blender Options:
* The Blender plugin features the option to save your blend file in a location outside of your godot project and then push the save to your godot directory when you're ready to push an update.
* You can also set .blend file wide default settings. These settings are overidden by individual settings on objects.

### Misc Fixes:
* The Metallic Specular setting on materials can now be controlled using the Specular IOR setting in Blender.
* You now have additional Godot specific options that can be set inside of Blender. This includes things like mesh transparency, stencil buffer settings, and more.


## Installation
Begin with downloading the newest release of the addon from the [Releases Page](https://github.com/XelophCode/simple-blender-pipeline/releases/tag/SimpleBlenderPipeline). This will be the 'simple_blender_pipeline_1.x.x.zip'. Inside of the zip will be an addon for Godot and an addon for Blender.

### Installing the Godot Addon:
Open the 'simple_blender_pipeline_1.x.x.zip/godot' folder. Inside you will find an 'addon' folder. Extract this 'addon' folder to your Godot project's root directory. The file system should look like this:<br>
<br>
<img width="280" height="207" alt="0708ec2baccf2b4c234e3a3a8a311956" src="https://github.com/user-attachments/assets/668d7746-bcf8-47cd-9572-e2741ec43ec7" />

Next, go to 'Project>Project Settings>Plugins' and enable the Simple Blender Pipeline addon.<br>
<br>
<img width="499" height="144" alt="99c9dde2382a0abc31f70d1ed1c3ba7a" src="https://github.com/user-attachments/assets/cc2b09ac-46e9-404d-9054-6f58ec3f1a79" />

Lastly, we need to go to 'Project>Project Settings>Import Defaults' and click on the dropdown menu next to 'Importer'. Select 'Scene' and scroll down to 'Import Script>Path' and click on the file browser icon to the right.<br>
<br>
<img width="531" height="151" alt="import_path" src="https://github.com/user-attachments/assets/a7e731f3-ca69-4eca-afc0-8a91412fb2f3" /><br>
<br>
Navigate to 'addons/simple_blender_pipeline' and select the import_script.gd file. Press the save button near the bottom of the window and then restart Godot to insure that the addon is initialized properly.<br>
<br>
<img width="886" height="222" alt="save" src="https://github.com/user-attachments/assets/0c1cc9ce-a8b1-497d-beda-30324b9e20ad" /><br>
<br>
You're done installing the Godot addon! If you already have blend files imported into your project you will need to either manually assign the import script to them or delete them from the project and re-add them for the addon to work properly.

### Installing the Blender Addon:
Open the 'simple_blender_pipeline_1.x.x.zip/blender' folder. Extract the 'simple_blender_pipeline_gd_1.0.5.zip' to somewhere that you can easily find it. Now open a new blender project and navigate to 'Edit>Preferences>Addons', click the dropdown arrow in the top right and select 'Install from Disk'.<br>
<br>
<img width="591" height="438" alt="d2da103aecbb7f66ae7f9ca50d754d00" src="https://github.com/user-attachments/assets/55619bd8-4000-4f66-97b6-f37633c3fd5b" />

