# Runtime Controls Remapping for Godot 4.x

A simple, lightweight plugin for quickly handling player controls remapping at runtime in Godot 4.x projects.

The plugin comes with one class (ControlsRemap) that handles all the backend and can be used with your own custom frontend implementation. However, if you want, you can also use the included InputRemapButton class to simplify the process further.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/L4L2128QIJ)

## Project Settings
Begin by setting up your Input Actions, as normal. Then, head on over to **Project Settings -> General -> Addons -> Controls Remap**. You will have to enable Advanced Settings in the upper right to see the secion (or search it via the search bar at the top).

### Remappable Actions
This is an Array that should only contain StringName values. Add the name of each of the actions you want to be able to remap. Those can be ones you defined yourself, or the built-in Godot ones (e.g., "ui_up").

### Events Dictionary
This is a dictionary that allows you to change the display text of an event. So, instead of your buttons saying "Joypad Motion on Axis 1 (Left Stick Y-Axis, Joystick 0 Y-Axis) with Value 1.00", they would say "Left Stick Down".

Set the default text (event.as_text()) that Godot returns as the key (type String) and the desired output text as the value in the dictionary (type String again).

Works with ControlsRemap.get_button_text() method.

### Action Names Dictionary
This dictionary allows you to set user-friendly action names to display in your UI. That way you can keep descriptive and easy-to-use action names in the InputMap, while displaying easily readable ones to the player.

The key of each dictionary entry must be the action's name from the default input map (StringName type). The value is the text you want to display to the player (String type).

Works with ControlsRemap.get_action_text() method.

## ControlsRemap
This script is added as a singleton (autoload) when the plugin is enabled. It handles all of the backend logic for remapping, saving, and loading key binds at runtime.

The script is meant to support joypad and mouse/keyboard control schemes at the same time. Meaning that if a keyboard/mouse input is passed during remapping, the joypad binds will remain unaffected and vice versa.

### Methods
Only methods meant to be used from other scripts are referenced in the table below. All methods that begin with an underscore are intended to be private and should not be called outside the ControlsRemap class.

<table><thead>
  <tr>
    <th>Method</th>
    <th>Parameters</th>
    <th>Return Type</th>
    <th>Description</th>
  </tr></thead>
<tbody>
  <tr>
    <td>remap_input</td>
    <td><ul><li>action: StringName</li><li>event: InputEvent</li></ul></td>
    <td>void</td>
    <td>Remaps the passed action's event to the passed event. Dynamically distinguishes between keyboard/mouse and joypad inputs on its own.</td>
  </tr>
  <tr>
    <td>is_action_remappable</td>
    <td>action: StringName</td>
    <td>bool</td>
    <td>Return true if the action can be remapped. Remappable actions are defined in the Project Settings (see section above).</td>
  </tr>
  <tr>
    <td>get_button_text</td>
    <td>event: InputEvent</td>
    <td>String</td>
    <td>If a custom text is set for the passed event in Project Settings (see section above), it is returned by this method. Otherwise, it returns event.as_text()</td>
  </tr>
  <tr>
    <td>get_action_text</td>
    <td>action: StringName</td>
    <td>String</td>
    <td>If a custom name is set for the action in Project Settings (see section above), it is returned by this method. Otherwise, it returns the action name, as set in the InputMap.</td>
  </tr>
  <tr>
    <td>get_remappable_actions</td>
    <td>N/A</td>
    <td>Array</td>
    <td>Returns the array of remappable actions, as defined in Project Settings (see section above).</td>
  </tr>
</tbody></table>

## InputRemapButton
This is a custom class that extends the built-in Godot Button class. It allows easily creating a remapping UI without adding too much custom logic. Buttons can be created via code (InputRemapButton.new()) or in the editor by instantiating them in the scene.

If the button is created via code, its **action** property must be set before it is added to the tree, as that property is validated in **_ready()**.

### Properties
|Property|Type|Description|Default Value|
|--------|----|-----------|-------------|
|action|StringName|The action that this remap button is responsible for. It must be an action that is defined as remappable in Project Settings (see above). Otherwise, the button is considered invalid and will not work.|N/A|
|is_joypad|bool|If true, then this button applies to the joypad mapping. Otherwise, it applies to the keyboard mapping.|false|
|awaiting_input_text|String|The text to be displayed in the button after it was clicked and before a new input is set by the player.|"..."|
|init_button_on_ready|bool|Whether the button should be initialised on _ready() if it is valid.|true|
