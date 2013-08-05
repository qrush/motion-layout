module Motion
  class Layout
    def initialize(&block)
      @verticals   = []
      @horizontals = []
      @metrics     = {}

      yield self
      strain
    end

    def metrics(metrics)
      @metrics = Hash[metrics.keys.map(&:to_s).zip(metrics.values)]
    end

    def subviews(subviews)
      @subviews = Hash[subviews.keys.map(&:to_s).zip(subviews.values)]
    end

    def view(view)
      @view = view
    end

    def horizontal(horizontal, *options)
      options = [0] if options.empty?
      @horizontals << [ horizontal, resolve_options(options) ]
    end

    def vertical(vertical, *options)
      options = [0] if options.empty?
      @verticals << [ vertical, resolve_options(options) ]
    end

    private

    def strain
      @subviews.values.each do |subview|
        subview.translatesAutoresizingMaskIntoConstraints = false
        @view.addSubview(subview)
      end

      constraints = []
      constraints += @verticals.map do |vertical, options|
        NSLayoutConstraint.constraintsWithVisualFormat("V:#{vertical}", options: options, metrics:@metrics, views:@subviews)
      end
      constraints += @horizontals.map do |horizontal, options|
        NSLayoutConstraint.constraintsWithVisualFormat("H:#{horizontal}", options: options, metrics:@metrics, views:@subviews)
      end

      @view.addConstraints(constraints.flatten)
    end

    def resolve_options(options)
      option_hash = {
        left: NSLayoutFormatAlignAllLeft,
        right: NSLayoutFormatAlignAllRight,
        top: NSLayoutFormatAlignAllTop,
        bottom: NSLayoutFormatAlignAllBottom,
        leading: NSLayoutFormatAlignAllLeading,
        trailing: NSLayoutFormatAlignAllTrailing,
        center_x: NSLayoutFormatAlignAllCenterX,
        center_y: NSLayoutFormatAlignAllCenterY,
        baseline: NSLayoutFormatAlignAllBaseline
      }
      options.inject(0) do |combined_result, option|
        if option.kind_of?(Numeric)
          combined_result | option.to_i
        elsif constant = option_hash[option.to_s.downcase.to_sym]
          combined_result | constant
        else
          raise "invalid option: #{option.to_s.downcase}"
        end
      end
    end
  end
end
