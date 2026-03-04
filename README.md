# Simple Blender Pipeline for Godot

## What is the Simple blender Pipeline?

The Simple Blender pipeline is an addon for both Blender and Godot that aims to make using .blend files in Godot easier. It leverages godot's node structure to allow the user to easily recompose the objects of a .blend file after importing it into Godot. The addon also aims to resolve some long standing issues with the default import pipeline. This addon is not a "kitchen sink" addon, it only focuses on what I think are the most pressing issues when working with .blend files.

## Features

### Recomposition:
* Automatic unpacking of .blend files when dragging its .tscn file into an open scene.
* SBP will take each individual object in the .blend file and add it to the current scene as it's own MeshInstance3D.
* You can then reorganize each of these MeshInstances as you see fit in your scene tree.
* If you make changes to the .blend file, your scene tree structure in Godot will be maintained.

<video width="630" height="300" src="https://github.com/user-attachments/assets/3e0f62eb-78f9-436e-9ef0-8852713d1af8"></video>


### Material Management:
* In Project Settings, you can define default material settings for imported materials.
* These project settings can be overridden via the blender addon if you need a specific material to have unique settings.

### Collision Shape Generation:
* Mesh objects can be tagged to auto generate CollisionShape3Ds on import.
* These CollisionShape3Ds can be recomposed just like the MeshInstance3Ds, This allows you to easily set up physics bodies in your scene tree and have your scene tree structure be respected if you make changes to the blend file.
* You can discard the mesh object if you only want the CollisionShape3D.
* The debug visuals in the Godot editor can be automatically hidden on import, this is useful for when you don't want your level geometry to be covered in a z-fighting blue mesh while working.

### Blender Options:
* The Blender plugin features the option to save your blend file in a location outside of your godot project and then push the save to your godot directory when you're ready to push an update.
* You can also set .blend file wide default settings. These settings are overidden by individual settings on objects.

### Misc Fixes:
* The Metallic Specular setting on materials can now be controlled using the Specular IOR setting in Blender.
* You now have additional Godot specific options that can be set inside of Blender. This includes things like mesh transparency, stencil buffer settings, and more.


## Installation

