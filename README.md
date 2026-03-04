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

[Getting Started](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#getting-started)
>[Importing Your Blend File](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#getting-started)<br>
>[Recomposition](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#recomposition-1)


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
You're done installing the Godot addon! It's recommended that you go ahead and create a folder for storing your blend files. Inside of your new blend folder, you will want to create a folder named "textures". If this folder doesn't already exist when importing a blend file, Godot will make the folder automatically but the SBP addon might glitch a bit as a result. One more thing to note, if you already have blend files imported into your project before installing the addon, you will need to manually assign the import script to them in Godot's importer menu.

### Installing the Blender Addon:
Open the 'simple_blender_pipeline_1.x.x.zip/blender' folder. Extract the 'simple_blender_pipeline_gd_1.x.x.zip' to somewhere that you can easily find it. Now open a new blender project and navigate to 'Edit>Preferences>Addons', click the dropdown arrow in the top right and select 'Install from Disk'.<br>
<br>
<img width="591" height="438" alt="d2da103aecbb7f66ae7f9ca50d754d00" src="https://github.com/user-attachments/assets/55619bd8-4000-4f66-97b6-f37633c3fd5b" /><br>
<br>
Navigate to where you extracted the 'simple_blender_pipeline_gd_1.x.x.zip' and select it. Make sure that this is the correct zip with the "gd" in it's name and not the zip that contains both plugins! The plugin is now installed, quickly double check that it's enabled with the checkbox checked next to the addon.<br>
<br>
<img width="591" height="432" alt="checked" src="https://github.com/user-attachments/assets/1d110769-6128-4c0e-af58-7530e5fab2ff" /><br>
<br>
Now close the Preferences window and navigate to 'File>External Data' and make sure that 'Automatically Pack Resources' is checked.<br>
<br>
<img width="428" height="555" alt="b9384f2e64a0840b779517b25d380f09" src="https://github.com/user-attachments/assets/1a58a4b2-00d1-4d79-ac2a-f230eedf5595" /><br>
<br>
Navigate to 'File>Defaults' and select 'Save Startup File'. This will ensure that the 'Automatically Pack Resources' setting is always checked in new blend files. It's important to note that this might not be desireable behavior in all usages of Blender, so this may need to be manually disabled when not using blender for the SBP plugin. This can be undone by simply unchecking the 'Automatically Pack Resources' and resaving the startup file.<br>
<br>
<img width="414" height="451" alt="909dc1e9e9567c25e5a67d5830e5f88a" src="https://github.com/user-attachments/assets/45a1e6f8-0497-4620-8788-6f338276d7cf" /><br>
<br>
The installation of the Blender addon is complete! You can access the addon by pressing the 'n' key, you will see the Simple Blender Pipeline GD tab in the main viewport.<br>
<br>
<img width="775" height="710" alt="f8ac91be87c8d5e4bf71fa0a366cb0c0" src="https://github.com/user-attachments/assets/6b4b6421-40cf-4776-b5f9-7004340eb6fb" /><br>
<br>

## Getting Started

Now that we have both addons installed we will begin exploring the features of the Simple Blender Pipeline!

### Importing Your Blend File:
Upon adding your blend file to your Godot project, Godot will automatically convert it internally to a .tscn file. When you drag this file into an open scene's scene tree, you will see a BlendFileUnpacker node, as well as a new "_unpacked" Node3D with the objects of the blend file as children. So long as the BlendFileUnpacker node is in the scene tree, you now have a hot reload link established. If you make changes to the blend file and press ctrl+s then those changes will automatically be reflected in Godot. The BlendFileUnpacker node can be deleted if you believe that you no longer need to make changes to the blend file. If you ever need to re-establish this link, simply re-add the blend file to the scene tree and it will generate a new BlendFileUnpacker.

https://github.com/user-attachments/assets/addc99b2-53ac-42d7-83ec-799e624c69e1

### Recomposition:
You can reparent any of the nodes under the "Unpacker" node. When you make changes to the .blend file,
