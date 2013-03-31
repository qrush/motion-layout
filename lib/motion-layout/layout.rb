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
      @metrics = metrics
    end

    def subviews(subviews)
      @subviews = subviews
    end

    def view(view)
      @view = view
    end

    def horizontal(horizontal, options = NSLayoutFormatAlignAllCenterY)
      @horizontals << [horizontal, options]
    end

    def vertical(vertical, options = NSLayoutFormatAlignAllCenterX)
      @verticals << [vertical, options]
    end

    private

    def strain
      @subviews.values.each do |subview|
        subview.translatesAutoresizingMaskIntoConstraints = false
        @view.addSubview(subview)
      end

      constraints = []
      constraints += @verticals.map do |layout, options|
        NSLayoutConstraint.constraintsWithVisualFormat("V:#{layout}", options:options, metrics:@metrics, views:@subviews)
      end
      constraints += @horizontals.map do |layout, options|
        NSLayoutConstraint.constraintsWithVisualFormat("H:#{layout}", options:options, metrics:@metrics, views:@subviews)
      end

      @view.addConstraints(constraints.flatten)
    end
  end
end
