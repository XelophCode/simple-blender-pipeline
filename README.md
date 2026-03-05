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
>[Recomposition](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#recomposition-1)<br>
>[Default Material Settings](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#default-material-settings)<br>
>[Blender Settings](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#blender-settings)<br>
>[Advanced Options](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#advanced-options)<br>
>[Misc Features](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#misc-features)

[Troubleshooting](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#troubleshooting)

>[When I drag the .blend file into a scene nothing happens](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#when-i-drag-the-blend-file-into-a-scene-nothing-happens)<br>
>[I'm saving my .blend file but it's not updating the unpacked nodes in the scene tree](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#im-saving-my-blend-file-but-its-not-updating-the-unpacked-nodes-in-the-scene-tree)<br>
>[The output messages are annoying](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#the-output-messages-are-annoying)<br>
>[Disabling the addon doesn't fully disable it](https://github.com/XelophCode/simple-blender-pipeline/tree/main?tab=readme-ov-file#disabling-the-addon-doesnt-fully-disable-it)



## What is the Simple Blender Pipeline?

The Simple Blender Pipeline is an addon for both Blender and Godot that aims to make using .blend files in Godot easier. It leverages Godot's node structure to allow the user to easily recompose the objects of a .blend file after importing it into Godot. The addon also aims to resolve some long-standing issues with the default import pipeline. This addon is not a "kitchen sink" addon, it only focuses on what I think are the most pressing issues when working with .blend files. My main focus is for the addon to be lightweight and intuitive to use.

## Features

### Recomposition:

* Automatic unpacking of .blend files when dragging its .tscn file into an open scene.

* SBP will take each individual object in the .blend file and add it to the current scene as its own MeshInstance3D.

* You can then reorganize each of these MeshInstances as you see fit in your scene tree.

* If you make changes to the .blend file, your scene tree structure in Godot will be maintained.

* Iteration is easy thanks to a hot reload system! Simply press ctrl+s in Blender to see your changes in Godot!

https://github.com/user-attachments/assets/3e0f62eb-78f9-436e-9ef0-8852713d1af8

### Material Management:

* In Project Settings, you can define default material settings for imported materials.

* These project settings can be overridden via the Blender addon if you need a specific material to have unique settings.

https://github.com/user-attachments/assets/12de0909-5681-47f7-a639-e895574be7cc

### Collision Shape Generation:

* Mesh objects can be tagged to auto generate CollisionShape3Ds on import.

* These CollisionShape3Ds can be recomposed just like the MeshInstance3Ds, This allows you to easily set up physics bodies in your scene tree and have your scene tree structure be respected if you make changes to the blend file.

* You can discard the mesh object if you only want the CollisionShape3D.

* The debug visuals in the Godot editor can be automatically hidden on import, this is useful for when you don't want your level geometry to be covered in a z-fighting blue mesh while working.

https://github.com/user-attachments/assets/b3db78fb-8991-4b13-a5ab-549476b6214b

### Blender Options:

* The Blender plugin features the option to save your blend file in a location outside of your Godot project and then push the save to your Godot directory when you're ready to push an update.

* You can also set .blend file-wide default settings. These settings are overidden by individual settings on objects.

### Misc Fixes:

* The Metallic Specular setting on materials can now be controlled using the Specular IOR setting in Blender.

* You now have additional Godot-specific options that can be set inside of Blender. This includes things like mesh transparency, stencil buffer settings, and more.

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

Open the 'simple_blender_pipeline_1.x.x.zip/blender' folder. Extract the 'simple_blender_pipeline_gd_1.x.x.zip' to somewhere that you can easily find it. Now open a new Blender project and navigate to 'Edit>Preferences>Addons', click the dropdown arrow in the top right and select 'Install from Disk'.<br>

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

Navigate to 'File>Defaults' and select 'Save Startup File'. This will ensure that the 'Automatically Pack Resources' setting is always checked in new blend files. It's important to note that this might not be desireable behavior in all usages of Blender, so this may need to be manually disabled when not using Blender for the SBP plugin. This can be undone by simply unchecking the 'Automatically Pack Resources' and resaving the startup file.<br>
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

One important thing to note about the hot reloading link is that the scene must be open for the hot reload to work automatically. If the currently open tab does not contain the blend scene you're updating, the update will fail. The output window will notify you of any blend files that were not updated, as well as BlendFileUnpacker nodes will change their icon to reflect that they are out of date. Simply pressing the 'Reload' button on the BlendFileUnpacker will resync with your blend file. If you're worried that there may be un-updated BlendFileUnpackers in your project, you can click the 'Scan' button on any BlendFileUnpacker and you will get a list of un-updated nodes in the output window. This is an unfortunate limitation of the engine but I've done my best to mitigate any annoyances.

https://github.com/user-attachments/assets/9699bd29-fd17-46ab-b36f-df7539de5eea

### Recomposition:

You can reparent any of the nodes under the "Unpacker" node. When you make changes to the .blend file, the unpacked nodes will maintain their position in the scene tree. This allows you to create blend files that contain models for multiple different uses that can be easily updated in the future. You can also combine this functionality with the collision shape generation to automatically create a collision shape for a mesh and then reparent it to a physics body. If you make changes to the mesh in Blender, those changes will automatically be reflected in Godot regardless of where it is in the scene tree.

https://github.com/user-attachments/assets/9a12e078-bd5a-472a-8e03-cf9186275d60

### Default Material Settings:

In Project Settings you can define the default settings for materials when they're imported into the engine. This can be useful for games that have a ubiquitous artstyle. Are you making a retro psx game with pixelated textures? Set the default texture filter to 'Nearest'. Are you making a game with toon shading? Set the diffuse and specular modes to 'Toon'. If you run into a rare situation where the overridden defaults aren't desireable, you can either revert them in the project settings or use the 'Override Project Settings' option in the Blender addon.

https://github.com/user-attachments/assets/e36bf36d-0e43-4c6b-88d2-855e322ab7c9

### Blender Settings:

By default when you update your blend file, Godot will automatically apply certain default settings to the imported tscn file. As a result, if you want an imported MeshInstance3D to have it's transparency set to 0.5 you will need to change this setting manually everytime that you update your blend file. This is where the Simple Blender Pipeline comes in! In the Blender addon, you can define both mesh and material overrides to ensure that your changes are respected. Some of these override options are redundant (such as texture filtering for example) but I chose to include them in the addon due to them either being slightly obscured in Blender or them not having full feature parity with Godot. There are even some overrides that allow access to previously inaccessible settings like Godot's stencil buffer. All settings are stored per object in its custom properties. You can still set your own custom properties, just make sure that they don't include "sbp" in their name as that's how the addon finds relevant metadata.

https://github.com/user-attachments/assets/e674cd50-675c-428c-9504-bd843509323e

### Advanced Options:

The Blender addon also features an advanced options menu. If you don't want every ctrl+s to automatically be pushed to your Godot project, you can save your .blend file outside of the project and instead use the 'Save Blend File to Godot' menu under 'Advanced Options'. Simply set the name of the file and choose where it will be saved and then press 'Save Blend' when you are ready to push changes to your Godot project! The advanced options menu also allows you to set .blend-wide override settings. For example, If you want everything in your .blend file to have 'Nearest' filtering applied by default, add a .blend override and set it's texture filtering. It's important to note that individual object overrides supercede a .blend-wide override. So if you want everything to be 'Nearest' filtering except for one object, simply set the exception's texture override to 'Linear'.

https://github.com/user-attachments/assets/65130f10-9ae4-41fb-bb11-976ced63bcc1

### Misc Features:

By default the addon does a few things, most of which can be disabled in the Project Settings in Godot.
* Specular IOR in Blender is used for the Metallic Specular setting on Godot materials.
* Float Arrays in Blender Custom Properties are automatically converted into Vector metadata in Godot.
* The Coat Tint property in Blender is used for the Stencil Color in Godot. This is a compromise to be able to properly store color data and may not be desireable if you're actually using the Coat Tint for something.
* All SBP metadata on meshes is automatically removed after import. This helps to declutter your imported mesh metadata if you have your own custom properties attached.

## Troubleshooting:

### When I drag the .blend file into a scene nothing happens.
Make sure that the blend file has it's import script set to import_script.gd. You can check this by double clicking the blend file in the FileSystem tab. Blend files that were imported BEFORE installing the plugin will not have the import script automatically attached.

### I'm saving my .blend file but it's not updating the unpacked nodes in the scene tree.
The addon's hot reload only works if the BlendFileUnpacker is present in the scene, and that scene tab is currently focused in the editor. If you are on a different open scene tab, the addon is unable to update the unpacked nodes automatically. Changes are still being made to the .blend file, you just need to navigate to the BlendFileUnpacker node and press 'Reload' to update. It's also good practice to periodically use the 'Scan' button on BlendFileUnpacker nodes to see if there's any scenes that are not up to date.

### The output messages are annoying.
This can be disabled in the Project Settings under Simple Blender Pipeline>Settings>Print Updates.

### Disabling the addon doesn't fully disable it.
To temporarily disable the addon, there's a setting under Project Settings that will fully stop functionality of the addon if set to true. If you wish to uninstall the addon, simply work your way backwards through the installation guide and delete all BlendFileUnpacker nodes from your project.

