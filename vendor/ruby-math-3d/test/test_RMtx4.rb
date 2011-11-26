class TC_RMtx4 < Test::Unit::TestCase

  def setup
    @tolerance = RMath::TOLERANCE
    @mZero = RMtx4.new.setZero
    @mIdentity = RMtx4.new.setIdentity
  end

  def teardown
  end

  def test_RMtx_initialize
    m0 = nil
    assert_nothing_raised { m0 = RMtx4.new }
    for r in 0...4 do
      for c in 0...4 do
        assert_equal( 0.0, m0.getElement(r,c) )
      end
    end

    m1 = nil
    assert_nothing_raised { m1 = RMtx4.new( 0, 1, 2, 3,
                                            4, 5, 6, 7,
                                            8, 9,10,11,
                                           12,13,14,15 ) }
    assert_equal( 0, m1.getElement(0,0) )
    assert_equal( 1, m1.getElement(0,1) )
    assert_equal( 2, m1.getElement(0,2) )
    assert_equal( 3, m1.getElement(0,3) )
    assert_equal( 4, m1.getElement(1,0) )
    assert_equal( 5, m1.getElement(1,1) )
    assert_equal( 6, m1.getElement(1,2) )
    assert_equal( 7, m1.getElement(1,3) )
    assert_equal( 8, m1.getElement(2,0) )
    assert_equal( 9, m1.getElement(2,1) )
    assert_equal(10, m1.getElement(2,2) )
    assert_equal(11, m1.getElement(2,3) )
    assert_equal(12, m1.getElement(3,0) )
    assert_equal(13, m1.getElement(3,1) )
    assert_equal(14, m1.getElement(3,2) )
    assert_equal(15, m1.getElement(3,3) )

    m2 = nil
    assert_nothing_raised { m2 = RMtx4.new( m1 ) }
    for r in 0...4 do
      for c in 0...4 do
        assert_equal( 4*r+c, m2.getElement(r,c) )
      end
    end
  end

  def test_to_s
    assert_respond_to( @mZero, :to_s )
  end

  def test_coerce
    assert_respond_to( @mZero, :coerce )
  end

  def test_setElements
    @mZero.setElements( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )
    for r in 0...4 do
      for c in 0...4 do
        assert_equal( 4*r+c, @mZero.getElement(r,c) )
      end
    end
  end

  def test_setElement
    for r in 0...4 do
      for c in 0...4 do
        @mZero.setElement( r, c, 4*r+c )
      end
    end
    for r in 0...4 do
      for c in 0...4 do
        assert_equal( 4*r+c, @mZero.getElement(r,c) )
      end
    end

    for r in 0...4 do
      for c in 0...4 do
        @mZero[ r, c ] = 4*c+r
      end
    end
    for r in 0...4 do
      for c in 0...4 do
        assert_equal( 4*c+r, @mZero[r,c] )
      end
    end
  end

  def test_getElement
    assert_respond_to( @mIdentity, :getElement )
    for r in 0...4 do
      for c in 0...4 do
        e = @mIdentity.getElement( r, c )
        if ( r == c )
          assert_equal( 1.0, e )
        else
          assert_equal( 0.0, e )
        end
      end
    end

    for r in 0...4 do
      for c in 0...4 do
        e = @mIdentity[r, c]
        if ( r == c )
          assert_equal( 1.0, e )
        else
          assert_equal( 0.0, e )
        end
      end
    end

    mtx = RMtx4.new(1,2,3,4,
                    5,6,7,8,
                    9,10,11,12,
                    13,14,15,16)
    assert_equal( mtx.e00, 1 )
    assert_equal( mtx.e01, 2 )
    assert_equal( mtx.e02, 3 )
    assert_equal( mtx.e03, 4 )
    assert_equal( mtx.e10, 5 )
    assert_equal( mtx.e11, 6 )
    assert_equal( mtx.e12, 7 )
    assert_equal( mtx.e13, 8 )
    assert_equal( mtx.e20, 9 )
    assert_equal( mtx.e21,10 )
    assert_equal( mtx.e22,11 )
    assert_equal( mtx.e23,12 )
    assert_equal( mtx.e30,13 )
    assert_equal( mtx.e31,14 )
    assert_equal( mtx.e32,15 )
    assert_equal( mtx.e33,16 )
  end

  def test_getRowColumn
    mtx = RMtx4.new(1,2,3,4,
                    5,6,7,8,
                    9,10,11,12,
                    13,14,15,16)

    v = mtx.getRow(0)
    assert_equal( v.x, 1 )
    assert_equal( v.y, 2 )
    assert_equal( v.z, 3 )
    assert_equal( v.w, 4 )

    v = mtx.getRow(1)
    assert_equal( v.x, 5 )
    assert_equal( v.y, 6 )
    assert_equal( v.z, 7 )
    assert_equal( v.w, 8 )

    v = mtx.getRow(2)
    assert_equal( v.x, 9 )
    assert_equal( v.y, 10)
    assert_equal( v.z, 11)
    assert_equal( v.w, 12)

    v = mtx.getRow(3)
    assert_equal( v.x, 13)
    assert_equal( v.y, 14)
    assert_equal( v.z, 15)
    assert_equal( v.w, 16)


    v = mtx.getColumn(0)
    assert_equal( v.x, 1 )
    assert_equal( v.y, 5 )
    assert_equal( v.z, 9 )
    assert_equal( v.w, 13)

    v = mtx.getColumn(1)
    assert_equal( v.x, 2 )
    assert_equal( v.y, 6 )
    assert_equal( v.z, 10)
    assert_equal( v.w, 14)

    v = mtx.getColumn(2)
    assert_equal( v.x, 3 )
    assert_equal( v.y, 7 )
    assert_equal( v.z, 11)
    assert_equal( v.w, 15)

    v = mtx.getColumn(3)
    assert_equal( v.x, 4 )
    assert_equal( v.y, 8 )
    assert_equal( v.z, 12)
    assert_equal( v.w, 16)
  end

  def test_setRowColumn
    mtx = RMtx4.new

    vr = [RVec4.new(1,2,3,4),RVec4.new(5,6,7,8),RVec4.new(9,10,11,12),RVec4.new(13,14,15,16)]
    mtx.setRow(vr[0],0)
    mtx.setRow(vr[1],1)
    mtx.setRow(vr[2],2)
    mtx.setRow(vr[3],3)
    assert_equal( mtx.e00, 1 )
    assert_equal( mtx.e01, 2 )
    assert_equal( mtx.e02, 3 )
    assert_equal( mtx.e03, 4 )
    assert_equal( mtx.e10, 5 )
    assert_equal( mtx.e11, 6 )
    assert_equal( mtx.e12, 7 )
    assert_equal( mtx.e13, 8 )
    assert_equal( mtx.e20, 9 )
    assert_equal( mtx.e21, 10)
    assert_equal( mtx.e22, 11)
    assert_equal( mtx.e23, 12)
    assert_equal( mtx.e30, 13)
    assert_equal( mtx.e31, 14)
    assert_equal( mtx.e32, 15)
    assert_equal( mtx.e33, 16)

    vc = [RVec4.new(1,2,3,4),RVec4.new(5,6,7,8),RVec4.new(9,10,11,12),RVec4.new(13,14,15,16)]
    mtx.setColumn(vc[0],0)
    mtx.setColumn(vc[1],1)
    mtx.setColumn(vc[2],2)
    mtx.setColumn(vc[3],3)
    assert_equal( mtx.e00, 1 )
    assert_equal( mtx.e01, 5 )
    assert_equal( mtx.e02, 9 )
    assert_equal( mtx.e03, 13)
    assert_equal( mtx.e10, 2 )
    assert_equal( mtx.e11, 6 )
    assert_equal( mtx.e12, 10)
    assert_equal( mtx.e13, 14)
    assert_equal( mtx.e20, 3 )
    assert_equal( mtx.e21, 7 )
    assert_equal( mtx.e22, 11)
    assert_equal( mtx.e23, 15)
    assert_equal( mtx.e30, 4 )
    assert_equal( mtx.e31, 8 )
    assert_equal( mtx.e32, 12)
    assert_equal( mtx.e33, 16)
  end

  def test_getUpper3x3
    m4 = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )
    m3 = m4.getUpper3x3
    assert_equal( m3.e00, 0 )
    assert_equal( m3.e01, 1 )
    assert_equal( m3.e02, 2 )
    assert_equal( m3.e10, 4 )
    assert_equal( m3.e11, 5 )
    assert_equal( m3.e12, 6 )
    assert_equal( m3.e20, 8 )
    assert_equal( m3.e21, 9 )
    assert_equal( m3.e22, 10)
  end

  def test_setUpper3x3
    m4 = RMtx4.new
    m3 = RMtx3.new( 1, 2, 3, 4, 5, 6, 7, 8, 9 )
    m4.setUpper3x3( m3 )
    assert_equal( m4.e00, 1 )
    assert_equal( m4.e01, 2 )
    assert_equal( m4.e02, 3 )
    assert_equal( m4.e10, 4 )
    assert_equal( m4.e11, 5 )
    assert_equal( m4.e12, 6 )
    assert_equal( m4.e20, 7 )
    assert_equal( m4.e21, 8 )
    assert_equal( m4.e22, 9 )
  end

  def test_setZero
    m = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )
    m.setZero
    for r in 0...4 do
      for c in 0...4 do
        assert_equal( 0.0, m.getElement( r, c ) )
      end
    end
  end

  def test_setIdentity
    m = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )
    m.setIdentity
    for r in 0...4 do
      for c in 0...4 do
        e = @mIdentity.getElement( r, c )
        if ( r == c )
          assert_equal( 1.0, e )
        else
          assert_equal( 0.0, e )
        end
      end
    end
  end

  def test_getDeterminant
    m0 = RMtx4.new( -2, 2, -3,  2,
                    -1, 1,  3, -2,
                     2, 0, -1,  1,
                     1, 0, -2,  3 )
    assert_in_delta( 27.0, m0.getDeterminant, @tolerance )
  end

  def test_transpose
    m0 = RMtx4.new( -2, 2, -3,  2,
                    -1, 1,  3, -2,
                     2, 0, -1,  1,
                     1, 0, -2,  3 )

    # RMtx4#getTransposed
    m1 = m0.getTransposed
    for r in 0...4 do
      for c in 0...4 do
        assert_equal( m0.getElement(c,r), m1.getElement(r,c) )
      end
    end

    # RMtx4#transpose!
    m0.transpose!
    for r in 0...4 do
      for c in 0...4 do
        assert_equal( m0.getElement(r,c), m1.getElement(r,c) )
      end
    end
  end

  def test_inverse
    m0 = RMtx4.new( -2, 2, -3,  2,
                    -1, 1,  3, -2,
                     2, 0, -1,  1,
                     1, 0, -2,  3 )

    m0inv = RMtx4.new( -1, 2, 15, -3,
                       8, 11, 15, -3,
                       -5, 10, -6, 12,
                       -3, 6, -9, 18 )
    m0inv *= 1.0/27.0

    # RMtx4#getInverse
    m1 =  m0.getInverse
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0inv.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end

    # RMtx3#invert!
    m0.invert!
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0inv.getElement(r,c), m0.getElement(r,c), @tolerance )
      end
    end
  end

  def test_translation
    m0 = RMtx4.new( 1.0, 0.0, 0.0, 10.0,
                    0.0, 1.0, 0.0, 10.0,
                    0.0, 0.0, 1.0, 10.0,
                    0.0, 0.0, 0.0,  1.0 )
    m1 = RMtx4.new.translation( 10.0, 10.0, 10.0 )
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationX
    m0 = RMtx4.new( 1.0, 0.0,              0.0,             0.0,
                    0.0, Math::sqrt(2)/2, -Math::sqrt(2)/2, 0.0,
                    0.0, Math::sqrt(2)/2,  Math::sqrt(2)/2, 0.0,
                    0.0, 0.0,              0.0,             1.0 )
    m1 = RMtx4.new.rotationX( Math::PI/4.0 )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end


    m2 = RMtx4.new( 1.0, 0.0,              0.0,             0.0,
                    0.0, 0.5,             -Math::sqrt(3)/2, 0.0,
                    0.0, Math::sqrt(3)/2,  0.5,             0.0,
                    0.0, 0.0,              0.0,             1.0 )
    m3 = RMtx4.new.rotationX( Math::PI/3.0 )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationY
    m0 = RMtx4.new(  Math::sqrt(2)/2, 0.0, Math::sqrt(2)/2, 0.0,
                     0.0,             1.0, 0.0,             0.0,
                    -Math::sqrt(2)/2, 0.0, Math::sqrt(2)/2, 0.0,
                     0.0,             0.0, 0.0,             1.0 ) 
    m1 = RMtx4.new.rotationY( Math::PI/4.0 )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end

    m2 = RMtx4.new(  0.5,             0.0, Math::sqrt(3)/2, 0.0,
                     0.0,             1.0, 0.0,             0.0,
                    -Math::sqrt(3)/2, 0.0, 0.5,             0.0,
                     0.0,             0.0, 0.0,             1.0 )
    m3 = RMtx4.new.rotationY( Math::PI/3.0 )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationZ
    m0 = RMtx4.new(  Math::sqrt(2)/2, -Math::sqrt(2)/2, 0.0, 0.0,
                     Math::sqrt(2)/2,  Math::sqrt(2)/2, 0.0, 0.0,
                     0.0,              0.0,             1.0, 0.0,
                     0.0,              0.0,             0.0, 1.0 )
    m1 = RMtx4.new.rotationZ( Math::PI/4.0 )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end

    m2 = RMtx4.new(  0.5,             -Math::sqrt(3)/2, 0.0, 0.0,
                     Math::sqrt(3)/2,  0.5,             0.0, 0.0,
                     0.0,              0.0,             1.0, 0.0,
                     0.0,              0.0,             0.0, 1.0 )
    m3 = RMtx4.new.rotationZ( Math::PI/3.0 )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationAxis
    m0 = RMtx4.new(  0.5,             -Math::sqrt(3)/2, 0.0, 0.0,
                     Math::sqrt(3)/2,  0.5,             0.0, 0.0,
                     0.0,              0.0,             1.0, 0.0,
                     0.0,              0.0,             0.0, 1.0 )
    m1 = RMtx4.new.rotationAxis( RVec3.new(0,0,1), Math::PI/3.0 )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationQuaternion
    q = RQuat.new.rotationAxis( RVec3.new(0,0,1), Math::PI/3.0 )
    m0 = RMtx4.new(  0.5,             -Math::sqrt(3)/2, 0.0, 0.0,
                     Math::sqrt(3)/2,  0.5,             0.0, 0.0,
                     0.0,              0.0,             1.0, 0.0,
                     0.0,              0.0,             0.0, 1.0 )
    m1 = RMtx4.new.rotationQuaternion( q )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end
  end

  def test_scaling
    m0 = RMtx4.new( 10.0,  0.0,  0.0, 0.0,
                     0.0, 20.0,  0.0, 0.0,
                     0.0,  0.0, 30.0, 0.0,
                     0.0,  0.0,  0.0, 1.0 )
    m1 = RMtx4.new.scaling( 10.0, 20.0, 30.0 )
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end
  end

  def test_lookAtRH
    pEye = RVec3.new( 10, 10, 10 )
    vDir = ( pEye - RVec3.new(0,0,0) ).normalize! # staring at (0,0,0)
    vUp = RVec3.new( 0, 1, 0 )
    vRight = RVec3.cross( vUp, vDir ).normalize!
    vUp = RVec3.cross( vDir, vRight ).normalize!

    m0 = RMtx4.new( vRight.x, vRight.y, vRight.z, -RVec3.dot(pEye,vRight),
                    vUp.x,    vUp.y,    vUp.z,    -RVec3.dot(pEye,vUp),
                    vDir.x,   vDir.y,   vDir.z,   -RVec3.dot(pEye,vDir),
                    0.0,      0.0,      0.0,       1.0    )

    m1 = RMtx4.new.lookAtRH( RVec3.new(10,10,10), # posistion
                             RVec3.new(0,0,0),    # at
                             RVec3.new(0,1,0) )   # up

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end
  end

  # http://pyopengl.sourceforge.net/documentation/manual/glFrustum.3G.html
  # http://pyopengl.sourceforge.net/documentation/manual/gluPerspective.3G.html
  def test_perspectiveRH
    left  = -640.0
    right =  640.0
    bottom = -360.0
    top    =  360.0
    z_n = 1.0
    z_f = 1000.0
    width = right - left
    height = top - bottom
    aspect = width/height

    # RMtx4#perspectiveRH
    m0 = RMtx4.new( 2*z_n/width, 0.0,          0.0,                  0.0,
                    0.0,         2*z_n/height, 0.0,                  0.0,
                    0.0,         0.0,         -(z_f+z_n)/(z_f-z_n), -2.0*z_f*z_n / (z_f-z_n),
                    0.0,         0.0,         -1.0,                  0.0 )
    m1 = RMtx4.new.perspectiveRH( width, height, z_n, z_f )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end

    # RMtx4#perspectiveFovRH

    # [NOTE] tan(fovy/2) == (height/2)/z_n
    fovy = 2.0 * Math::atan( (height/2.0) / z_n )
    f = 1.0/Math::tan( fovy/2.0 )

    m2 = RMtx4.new( f/aspect, 0.0,  0.0,                 0.0,
                    0.0,      f,    0.0,                 0.0,
                    0.0,      0.0,  (z_f+z_n)/(z_n-z_f), 2*z_f*z_n/(z_n-z_f),
                    0.0,      0.0, -1.0,                 0.0 )
    m3 = RMtx4.new.perspectiveFovRH( fovy, aspect, z_n, z_f );

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end

    # RMtx4#perspectiveOffCenterRH

    a = (right+left)/(right-left)
    b = (top+bottom)/(top-bottom)
    c = -(z_f+z_n)/(z_f-z_n)
    d = -2.0*z_f*z_n/(z_f-z_n)
    m4 = RMtx4.new( 2*z_n/(right-left), 0.0,                a,   0.0,
                    0.0,                2*z_n/(top-bottom), b,   0.0,
                    0.0,                0.0,                c,   d,
                    0.0,                0.0,               -1.0, 0.0 )

    m5 = RMtx4.new.perspectiveOffCenterRH( left, right, bottom, top, z_n, z_f )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m4.getElement(r,c), m5.getElement(r,c), @tolerance )
      end
    end
  end

  # http://pyopengl.sourceforge.net/documentation/manual/glOrtho.3G.xml
  def test_orthoRH
    left  = -640.0
    right =  640.0
    bottom = -360.0
    top    =  360.0
    z_n = 1.0
    z_f = 1000.0
    width = right - left
    height = top - bottom

    # RMtx4#orthoRH
    tx = (right+left)/width
    ty = (top+bottom)/height
    tz = (z_f+z_n)/(z_f-z_n)
    m0 = RMtx4.new( 2.0/width, 0.0,         0.0,           tx,
                    0.0,       2.0/height,  0.0,           ty,
                    0.0,       0.0,        -2.0/(z_f-z_n), tz,
                    0.0,       0.0,         0.0,           1.0 )
    m1 = RMtx4.new.orthoRH( width, height, z_n, z_f )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end

    # RMtx4#orthoOffCenterRH
    tx = (right+left)/(right-left)
    ty = (top+bottom)/(top-bottom)
    tz = (z_f+z_n)/(z_f-z_n)
    m2 = RMtx4.new( 2.0/(right-left), 0.0,               0.0,           tx,
                    0.0,              2.0/(top-bottom),  0.0,           ty,
                    0.0,              0.0,              -2.0/(z_f-z_n), tz,
                    0.0,              0.0,               0.0,           1.0 )
    m3 = RMtx4.new.orthoOffCenterRH( left, right, bottom, top, z_n, z_f )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end
  end

  def test_unary_operators
    # RMtx4#+@
    m0 = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )
    m1 = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )
    m2 = +m0

    assert_same( m0, m2 )
    assert_not_same( m1, m2 )

    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( 4*r+c, m2.getElement(r,c), @tolerance )
      end
    end

    # RMtx4#-@
    m2 = -m0
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0.getElement(r,c), -m2.getElement(r,c), @tolerance )
      end
    end
  end

  def test_binary_plus
    m0 = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 )
    m1 = RMtx4.new(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31 )
    m2 = RMtx4.new(16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46 )

    # RMtx4#+
    m3 = m0 + m1
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end

    # RMtx4#add!
    m0.add!( m1 )
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m0.getElement(r,c), @tolerance )
      end
    end
  end

  def test_binary_minus
    m0 = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 )
    m1 = RMtx4.new(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31 )
    m2 = RMtx4.new(-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16)

    # RMtx4#-
    m3 = m0 - m1
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end

    # RMtx4#sub!
    m0.sub!( m1 )
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m2.getElement(r,c), m0.getElement(r,c), @tolerance )
      end
    end
  end

  def test_binary_mult
    m0 = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 )
    m1 = RMtx4.new(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31 )
    m0x1 = RMtx4.new( 152, 158, 164, 170, 504, 526, 548, 570, 856, 894, 932, 970, 1208, 1262, 1316, 1370 )
    m1x0 = RMtx4.new( 440, 510, 580, 650, 536, 622, 708, 794, 632, 734, 836, 938, 728, 846, 964, 1082 )

    # RMtx4#*
    m2 = m0 * m1
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0x1.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end

    m2 = m1 * m0
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m1x0.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end

    # RMtx4#mul!
    m2 = RMtx4.new( m0 )
    m2.mul!( m1 )
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m0x1.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end

    m2 = RMtx4.new( m1 )
    m2.mul!( m0 )
    for r in 0...4 do
      for c in 0...4 do
        assert_in_delta( m1x0.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end
  end

  def test_equality_operators
    m0 = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 )
    m1 = RMtx4.new( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 )
    m2 = RMtx4.new(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31 )

    assert( m0 == m1 )
    assert( m0 != m2 )
  end

end
