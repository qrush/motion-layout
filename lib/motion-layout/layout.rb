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

    def horizontal(horizontal)
      @horizontals << horizontal
    end

    def vertical(vertical)
      @verticals << vertical
    end

    private

    def strain
      @subviews.values.each do |subview|
        subview.translatesAutoresizingMaskIntoConstraints = false
        @view.addSubview(subview)
      end

      constraints = []
      constraints += @verticals.map do |vertical|
        NSLayoutConstraint.constraintsWithVisualFormat("V:#{vertical}", options:NSLayoutFormatAlignAllCenterX, metrics:@metrics, views:@subviews)
      end
      constraints += @horizontals.map do |horizontal|
        NSLayoutConstraint.constraintsWithVisualFormat("H:#{horizontal}", options:NSLayoutFormatAlignAllCenterY, metrics:@metrics, views:@subviews)
      end

      @view.addConstraints(constraints.flatten)
    end
  end
end
