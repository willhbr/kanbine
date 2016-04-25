module Kanbine
  module IssueOrder
    START_POSITION = 0
    POSITION_GAP = 32

    def self.new_position(issue, up_issue, down_issue)
      up_pos = up_issue.nil? ? 0 : up_issue.kanban_position
      down_pos = down_issue.nil? ? 0 : down_issue.kanban_position

      if up_pos == nil || down_pos == nil || up_pos + 1 >= down_pos
        # If it's unarrangable, then return nil and then we'll call rearrange()
        # to sort out all the issues
        return nil
      end
      return ((up_pos + down_pos) / 2).to_i
    end

    # issues should be an array of Issue models, already in position order.
    # get_position_after is the id of a record to return the new position
    # of a record to insert after it
    def self.rearrange(issues, options={})
      get_position_after = options[:get_position_after]
      start_position = options[:start_position] || START_POSITION
      position = start_position
      res_position = nil
      issues.each do |issue|
        issue.update_column(:kanban_position, position)
        if issue.id == get_position_after
          position += POSITION_GAP
          res_position = position
        end
        position += POSITION_GAP
      end
      return res_position
    end
  end
end
