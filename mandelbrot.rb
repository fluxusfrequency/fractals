# Adapted to Ruby from http://processing.org/examples/mandelbrot.html

require 'ruby-processing'

class MandelbrotFractal < Processing::App

  attr_accessor :x, :y, :xmin, :xmax, :ymin, :ymax, :dx, :dy, :w, :h, :maxiterations, :a, :b, :n, :aa, :bb, :twoab

  def setup
    size(640, 360)
    # noLoop()
    background(255)

    # Make sure we can write to the pixels[] array.
    # Only need to do this once since we don't do any other drawing.
    loadPixels()


    # Establish a range of values on the complex plane
    # A different range will allow us to "zoom" in or out on the fractal
    # float xmin = -1.5 float ymin = -.1 float wh = 0.15
    @xmin = -1.8
    @ymin = -1.7
    @w = 3.0
    @h = 3.0


    # Maximum number of iterations for each point on the complex plane
    @maxiterations = 1


    # x goes from xmin to xmax
    # y goes from ymin to ymax
    @xmax = xmin + w
    @ymax = ymin + h


    # Calculate amount we increment x,y for each pixel
    @dx = (xmax - xmin) / (width)
    @dy = (ymax - ymin) / (height)

    @going_up = false
  end




  def draw
    puts "Drawing"
    # Start y
    @y = ymin
    for j in 0..height-1 do
      # Start x
      @x = xmin
      for i in 0..width-1 do


        # Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
        @a = x
        @b = y
        @n = 0
        while @n < maxiterations do
          @aa = a * a
          @bb = b * b
          @twoab = 2.0 * a * b
          @a = aa - bb + x
          @b = twoab + y
          # Infinty in our finite world is simple, let's just consider it 16
          if @aa + @bb > 16.0
            break  # Bail
          end
          @n += 1
        end

        # We color each pixel based on how long it takes to get to infinity
        # If we never got there, let's pick the color black
        if @n == maxiterations
          pixels[i+j*width] = color(@n*16 % 200, @n*16 % 64, @n*16 % 256)
        else
          # Gosh, we could make fancy colors here if we wanted
          pixels[i+j*width] = color(@n*16 % 200, @n*16 % 64, @n*16 % 256)
        end
        @x += @dx
      end
      @y += @dy
    end
    updatePixels()
    @maxiterations += 2
    # update_range
  end

  def update_range
    if @going_up
      count_up
      @going_up == false # if @xmin >= -0.5 || @xmin == 0
    else
      count_down
      @going_up == true # if @xmin <= -5.0
    end
  end

  def count_up
    @xmin = @xmin + 0.1
    @ymin = @ymin + 0.25
    @w = @w + 0.1
    @h = @h + 0.1
    @xmax = xmin + w
    @ymax = ymin + h
  end

  def count_down
    @xmin = @xmin - 0.1
    @ymin = @ymin - 0.25
    @w = @w - 0.1
    @h = @h - 0.1
    @xmax = xmin + w
    @ymax = ymin + h
  end

end

MandelbrotFractal.new(:title => "Fractals, Brah!", :full_screen => false)
