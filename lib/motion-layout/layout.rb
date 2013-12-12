module Motion
  class Layout
    OPTIONS = {
      left: NSLayoutFormatAlignAllLeft,
      right: NSLayoutFormatAlignAllRight,
      top: NSLayoutFormatAlignAllTop,
      bottom: NSLayoutFormatAlignAllBottom,
      leading: NSLayoutFormatAlignAllLeading,
      trailing: NSLayoutFormatAlignAllTrailing,
      centerx: NSLayoutFormatAlignAllCenterX,
      centery: NSLayoutFormatAlignAllCenterY,
      baseline: NSLayoutFormatAlignAllBaseline,
      leading_to_trailing: NSLayoutFormatDirectionLeadingToTrailing,
      left_to_right: NSLayoutFormatDirectionLeftToRight,
      right_to_left: NSLayoutFormatDirectionRightToLeft
    }
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
      options = [:centery] if options.empty?
      @horizontals << [horizontal, resolve_options(options)]
    end

    def vertical(vertical, *options)
      options = [:centerx] if options.empty?
      @verticals << [vertical, resolve_options(options)]
    end

    private

    def resolve_options(opt)
      opt.inject(0) do |m,x|
        if x.kind_of?(Numeric)
          m | x.to_i
        elsif o = OPTIONS[x.to_s.downcase.to_sym]
          m | o
        else
          raise "invalid opt: #{x.to_s.downcase}"
        end
      end
    end

    def strain
      @subviews.values.each do |subview|
        next if @view == subview # you wouldn't believe the mess it would create
        subview.translatesAutoresizingMaskIntoConstraints = false
        @view.addSubview(subview)
      end

      constraints = []
      constraints += @verticals.map do |vertical, options|
        NSLayoutConstraint.constraintsWithVisualFormat("V:#{vertical}", options:options, metrics:@metrics, views:@subviews)
      end
      constraints += @horizontals.map do |horizontal, options|
        NSLayoutConstraint.constraintsWithVisualFormat("H:#{horizontal}", options:options, metrics:@metrics, views:@subviews)
      end

      @view.addConstraints(constraints.flatten)
    end
  end
end
