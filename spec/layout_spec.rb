describe Motion::Layout do
    context "responds to its public methods" do
        before do
            @layout = Motion::Layout.new do |layout|
                layout.view UIView.alloc.init
                layout.subviews sub_view: UIView.alloc.init
                layout.horizontal "|[sub_view]|"
            end
        end

        it "#view" do
            @layout.should.respond_to? :view
        end

        it "#vertical" do
            @layout.should.respond_to? :vertical
        end

        it "#horizontal" do
            @layout.should.respond_to? :horizontal
        end

        it "#subviews" do
            @layout.should.respond_to? :subviews
        end

        it "#metrics" do
            @layout.should.respond_to? :metrics
        end
    end

    context "#initialize" do
        before do
            @view = UIView.alloc.init
            @horizontal_sub_view = UIView.alloc.init
            @vertical_sub_view = UIView.alloc.init

            Motion::Layout.new do |layout|
                layout.view @view
                layout.subviews horizontal_sub_view: @horizontal_sub_view, vertical_sub_view: @vertical_sub_view
                layout.horizontal "|-10-[horizontal_sub_view]-20-|"
                layout.vertical "|-100-[vertical_sub_view]-200-|"
            end
        end

        it "adds correct amount of constraints" do
            @view.constraints.size.should.equal(4)
        end

        it "adds subviews to vertical constraint" do
            constraint = @view.constraints.first
            constraint.firstItem.should.equal(@vertical_sub_view)
            constraint.secondItem.should.equal(@view)
        end

        it "adds subviews to horizontal constraint" do
            constraint = @view.constraints[2]
            constraint.firstItem.should.equal(@horizontal_sub_view)
            constraint.secondItem.should.equal(@view)
        end

        it "adds correct constants to horizontal constraint" do
            first_constraint = @view.constraints[0]
            second_constraint = @view.constraints[1]
            first_constraint.constant.should.equal(100)
            second_constraint.constant.should.equal(200)
        end

        it "adds correct constants to vertical constraint" do
            first_constraint = @view.constraints[2]
            second_constraint = @view.constraints[3]
            first_constraint.constant.should.equal(10)
            second_constraint.constant.should.equal(20)
        end
    end
end