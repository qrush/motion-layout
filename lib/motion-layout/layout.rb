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
        @view.addSubview(subview) unless subview.superview
      end

      views = @subviews.merge("superview" => @view)

      constraints = []
      constraints += @verticals.map do |vertical|
        NSLayoutConstraint.constraintsWithVisualFormat("V:#{vertical}", options:NSLayoutFormatAlignAllCenterY, metrics:@metrics, views:views)
      end
      constraints += @horizontals.map do |horizontal|
        NSLayoutConstraint.constraintsWithVisualFormat("H:#{horizontal}", options:NSLayoutFormatAlignAllCenterX, metrics:@metrics, views:views)
      end

      @view.addConstraints(constraints.flatten)
    end
  end
end
