# Kanbine

_Kanban for Redmine_

## Integrations

Kanbine integrates with Redmine Backlogs and Redmine Grouped Tags to colour the issues on the kanban screen. If Backlogs is installed then the colour of the story theme is used. If the tags plugin is installed, then a preference appears in the settings to select the tag group to use for the colour. Tags will always take priority over backlogs. If neither are installed it will fall back to the default auto-generated colours.

## Requirements

+ Redmine >= 3
+ Ruby >= 1.9.3
+ Rails 4(.2)

## Hooks

Kanbine has a number of hooks that can be used to add content to the kanban board without having to extend the plugin itself. These changes can be made in a separate plugin or as a part of Kanbine itself. These are normal Redmine hooks, and are used like so:

```ruby
module BacklogsPlugin
  class LayoutHook < Redmine::Hook::ViewListener
    # This will render the given partial view above the kanban board.
    render_on :view_kanbine_above_container, :partial => "backlogs/kanbine_taskboard_link"
  end
end
```

The current hooks are:

+ `view_kanbine_above_container`/ `view_kanbine_below_container`
  + For adding extra components/ assets to the main kanban board
  + No locals
+ `view_kanbine_above_column`/ `view_kanbine_below_column`
  + Adding info to each column
  + Passed the status of the column and the issues in the column
+ `view_kanbine_issue_editable_fields_form`
  + Adding editable fields to the update/ create dialog
  + Passed the formbuilder to use to make the form
  + This needs to be used in conjuction with:
+ `view_kanbine_issue_editable_fields_data`
  + Adding editable fields to issues. Will be used to populate the form
  + Should consist of any number of elements like:

  ```html
  <span id="field_name">field_value</span>
  ```

  + `field_name` will populate `issue_field_name` in the dialog form, with value `field_value`
  + Passed the issue to get the data from
+ `view_kanbine_header_tags`
  + To just add styles/ javascripts to the kanban page.
  + Will be included in the page `<head>`
