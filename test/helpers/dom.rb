module Helpers
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until no_ajax?
    end
  end

  def no_ajax?
    # Because of multiple jQuery/ noconflict things being used, this should
    # hopefully get all the different ajax things and see if they're active
    script = <<-eos
      (function() {
        var total = 0;
        if (typeof jQuery === 'function') {
          total += jQuery.active;
        }
        if (typeof jQuery2 === 'function') {
          total += jQuery2.active;
        }
        if (typeof $ === 'function') {
          total += $.active;
        }
        return total;
      })();
    eos
    page.evaluate_script(script).zero?
  end

  def click_id(id)
    find(id).click
  end

  def check_all(*args)
    args.each do |arg|
      check arg.to_s
    end
  end
end
