# Check preloading (-rRMath.so or -rRMath.rb)
unless $".find { |lib| lib =~ /RMath\.so|RMath\.rb/ }
  # Load RMath normally.
  begin
    require 'RMath.so'
  rescue LoadError
    # RMath.so does not exist. Require plain version.
    require 'RMath.rb'
  end
end
include RMath

require 'opengl'

class App

  def draw
    glPushAttrib( GL_ALL_ATTRIB_BITS )

    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT )

    glMatrixMode( GL_MODELVIEW )
    glLoadMatrix( @mtxLookAt )

    glLightfv( GL_LIGHT0, GL_POSITION, @light_pos )
    glLightfv( GL_LIGHT0, GL_DIFFUSE,  @light_diffuse )
    glLightfv( GL_LIGHT0, GL_SPECULAR, @light_specular )
    glLightfv( GL_LIGHT0, GL_AMBIENT,  @light_ambient )

    glPushMatrix()

    @mtxTeapotRotY.rotationY( @teapot_rad_y )
    glMultMatrix( @mtxTeapotRotY )
    @teapot_rad_y += 2.0*Math::PI/60.0

    glMaterialfv( GL_FRONT_AND_BACK, GL_DIFFUSE,   @teapot_diffuse )
    glMaterialfv( GL_FRONT_AND_BACK, GL_SPECULAR,  @teapot_specular )
    glMaterialfv( GL_FRONT_AND_BACK, GL_AMBIENT,   @teapot_ambient )
    glMaterialf(  GL_FRONT_AND_BACK, GL_SHININESS, @teapot_shininess )
    glutSolidTeapot( 2.0 )

    glPopMatrix()

    glPopAttrib()

    glutSwapBuffers()
  end


  def reshape( width, height )
    glViewport( 0, 0, width, height )
    glMatrixMode( GL_PROJECTION )
    @mtxProj.perspectiveFovRH( 30.0*Math::PI/180.0, width.to_f/height.to_f, 0.1, 1000.0 )
    glLoadMatrix( @mtxProj )

    @window_width  = width
    @window_height = height

    glutPostRedisplay()
  end


  def timer( value )
    glutPostRedisplay()
    glutTimerFunc( 1000/60, method(:timer).to_proc, 0 )
  end


  def key( key, x, y )
    case key
    when ?\e, ?q
      exit
    end
  end


  def initialize
    @window_width  = 320
    @window_height = 240

    @eye = RVec3.new(0.0, 15.0, 15.0)
    @at  = RVec3.new(0.0,  0.0,  0.0)
    @up  = RVec3.new(0.0,  1.0,  0.0)
    @mtxLookAt = RMtx4.new.lookAtRH( @eye, @at, @up )
    @mtxProj = RMtx4.new.perspectiveFovRH( 30.0*Math::PI/180.0, @window_width.to_f/@window_height.to_f, 0.1, 1000.0 )

    @light_pos = [2.5,0,5,1]
    @light_diffuse  = [1,1,1,1]
    @light_specular = [1,1,1,1]
    @light_ambient  = [1,1,1,1]

    @teapot_diffuse = [0.8,1,0,1]
    @teapot_specular = [1,1,1,1]
    @teapot_ambient = [0.2,0.2,0,1]
    @teapot_shininess = 32.0

    @teapot_rad_y = 0.0
    @mtxTeapotRotY = RMtx4.new.rotationY( @teapot_rad_y )

    glutInit()

    glutInitDisplayMode( GLUT_RGBA | GLUT_DEPTH | GLUT_DOUBLE )
    glutInitWindowPosition( 0, 0 )
    glutInitWindowSize( @window_width, @window_height )
    glutCreateWindow( self.class.to_s )

    glutDisplayFunc( method(:draw).to_proc )
    glutReshapeFunc( method(:reshape).to_proc )
    glutKeyboardFunc( method(:key).to_proc )
    glutTimerFunc( 0, method(:timer).to_proc, 0 )

    # Common rendering state : reused by PushAttrib/PopAttrib
    glEnable( GL_DEPTH_TEST )
    glEnable( GL_LIGHTING )
    glEnable( GL_LIGHT0 )
    glEnable( GL_NORMALIZE )
    glClearColor( 0.0, 0.0, 0.0, 1 )
  end

  def start
    glutMainLoop()
  end

end

App.new.start
