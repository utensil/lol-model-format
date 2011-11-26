class TC_RMtx3 < Test::Unit::TestCase

  def setup
    @tolerance = RMath::TOLERANCE
    @mZero = RMtx3.new.setZero
    @mIdentity = RMtx3.new.setIdentity
  end

  def teardown
  end

  def test_RMtx_initialize
    m0 = nil
    assert_nothing_raised { m0 = RMtx3.new }
    for r in 0...3 do
      for c in 0...3 do
        assert_equal( 0.0, m0.getElement(r,c) )
      end
    end

    m1 = nil
    assert_nothing_raised { m1 = RMtx3.new( 0, 1, 2,
                                            3, 4, 5,
                                            6, 7, 8 ) }
    assert_equal( 0, m1.getElement(0,0) )
    assert_equal( 1, m1.getElement(0,1) )
    assert_equal( 2, m1.getElement(0,2) )
    assert_equal( 3, m1.getElement(1,0) )
    assert_equal( 4, m1.getElement(1,1) )
    assert_equal( 5, m1.getElement(1,2) )
    assert_equal( 6, m1.getElement(2,0) )
    assert_equal( 7, m1.getElement(2,1) )
    assert_equal( 8, m1.getElement(2,2) )

    m2 = nil
    assert_nothing_raised { m2 = RMtx3.new( m1 ) }
    for r in 0...3 do
      for c in 0...3 do
        assert_equal( 3*r+c, m2.getElement(r,c) )
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
    @mZero.setElements( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    for r in 0...3 do
      for c in 0...3 do
        assert_equal( 3*r+c, @mZero.getElement(r,c) )
      end
    end
  end

  def test_setElement
    for r in 0...3 do
      for c in 0...3 do
        @mZero.setElement( r, c, 3*r+c )
      end
    end
    for r in 0...3 do
      for c in 0...3 do
        assert_equal( 3*r+c, @mZero.getElement(r,c) )
      end
    end

    for r in 0...3 do
      for c in 0...3 do
        @mZero[r, c] = 3*c+r
      end
    end
    for r in 0...3 do
      for c in 0...3 do
        assert_equal( 3*c+r, @mZero[r,c] )
      end
    end
  end

  def test_getElement
    assert_respond_to( @mIdentity, :getElement )
    for r in 0...3 do
      for c in 0...3 do
        e = @mIdentity.getElement( r, c )
        if ( r == c )
          assert_equal( 1.0, e )
        else
          assert_equal( 0.0, e )
        end
      end
    end

    for r in 0...3 do
      for c in 0...3 do
        e = @mIdentity[ r, c ]
        if ( r == c )
          assert_equal( 1.0, e )
        else
          assert_equal( 0.0, e )
        end
      end
    end

    mtx = RMtx3.new(1,2,3,
                    4,5,6,
                    7,8,9)
    assert_equal( mtx.e00, 1 )
    assert_equal( mtx.e01, 2 )
    assert_equal( mtx.e02, 3 )
    assert_equal( mtx.e10, 4 )
    assert_equal( mtx.e11, 5 )
    assert_equal( mtx.e12, 6 )
    assert_equal( mtx.e20, 7 )
    assert_equal( mtx.e21, 8 )
    assert_equal( mtx.e22, 9 )
  end

  def test_getRowColumn
    mtx = RMtx3.new(1,2,3,
                    4,5,6,
                    7,8,9)

    v = mtx.getRow(0)
    assert_equal( v.x, 1 )
    assert_equal( v.y, 2 )
    assert_equal( v.z, 3 )

    v = mtx.getRow(1)
    assert_equal( v.x, 4 )
    assert_equal( v.y, 5 )
    assert_equal( v.z, 6 )

    v = mtx.getRow(2)
    assert_equal( v.x, 7 )
    assert_equal( v.y, 8 )
    assert_equal( v.z, 9 )

    v = mtx.getColumn(0)
    assert_equal( v.x, 1 )
    assert_equal( v.y, 4 )
    assert_equal( v.z, 7 )

    v = mtx.getColumn(1)
    assert_equal( v.x, 2 )
    assert_equal( v.y, 5 )
    assert_equal( v.z, 8 )

    v = mtx.getColumn(2)
    assert_equal( v.x, 3 )
    assert_equal( v.y, 6 )
    assert_equal( v.z, 9 )
  end

  def test_setRowColumn
    mtx = RMtx3.new

    vr = [RVec3.new(1,2,3),RVec3.new(4,5,6),RVec3.new(7,8,9)]
    mtx.setRow(vr[0],0)
    mtx.setRow(vr[1],1)
    mtx.setRow(vr[2],2)
    assert_equal( mtx.e00, 1 )
    assert_equal( mtx.e01, 2 )
    assert_equal( mtx.e02, 3 )
    assert_equal( mtx.e10, 4 )
    assert_equal( mtx.e11, 5 )
    assert_equal( mtx.e12, 6 )
    assert_equal( mtx.e20, 7 )
    assert_equal( mtx.e21, 8 )
    assert_equal( mtx.e22, 9 )

    vc = [RVec3.new(1,2,3),RVec3.new(4,5,6),RVec3.new(7,8,9)]
    mtx.setColumn(vc[0],0)
    mtx.setColumn(vc[1],1)
    mtx.setColumn(vc[2],2)
    assert_equal( mtx.e00, 1 )
    assert_equal( mtx.e01, 4 )
    assert_equal( mtx.e02, 7 )
    assert_equal( mtx.e10, 2 )
    assert_equal( mtx.e11, 5 )
    assert_equal( mtx.e12, 8 )
    assert_equal( mtx.e20, 3 )
    assert_equal( mtx.e21, 6 )
    assert_equal( mtx.e22, 9 )
  end

  def test_setZero
    m = RMtx3.new( 1, 2, 3, 4, 5, 6, 7, 8, 9 )
    m.setZero
    for r in 0...3 do
      for c in 0...3 do
        assert_equal( 0.0, m.getElement( r, c ) )
      end
    end
  end

  def test_setIdentity
    m = RMtx3.new( 1, 2, 3, 4, 5, 6, 7, 8, 9 )
    m.setIdentity
    for r in 0...3 do
      for c in 0...3 do
        e = @mIdentity.getElement( r, c )
        if ( r == c )
          assert_equal( 1.0, e )
        else
          assert_equal( 0.0, e )
        end
      end
    end
  end

  # http://en.wikipedia.org/wiki/Determinant
  def test_getDeterminant
    m0 = RMtx3.new( -2, 2, -3,
                    -1, 1,  3,
                     2, 0, -1 )
    assert_equal( 18.0, m0.getDeterminant )

    m1 = RMtx3.new( 0, 2, -3,
                    0, 1,  3,
                    2, 0, -1 )
    assert_equal( 18.0, m1.getDeterminant )

    m2 = RMtx3.new( Math::sqrt(2)/2, -Math::sqrt(2)/2, 0.0,
                    Math::sqrt(2)/2,  Math::sqrt(2)/2, 0.0,
                    0.0,              0.0,             1.0 )
    assert_in_delta( 1.0, m2.getDeterminant, @tolerance )
  end

  def test_transpose
    m0 = RMtx3.new( -2, 2, -3,
                    -1, 1,  3,
                     2, 0, -1 )
    # RMtx3#getTransposed
    m1 = m0.getTransposed
    for r in 0...3 do
      for c in 0...3 do
        assert_equal( m0.getElement(c,r), m1.getElement(r,c) )
      end
    end

    # RMtx3#transpose!
    m0.transpose!
    for r in 0...3 do
      for c in 0...3 do
        assert_equal( m0.getElement(r,c), m1.getElement(r,c) )
      end
    end
  end

  # http://people.hofstra.edu/Stefan_waner/RealWorld/tutorialsf1/frames3_3.html
  # http://numericalmethods.eng.usf.edu/mws/gen/04sle/mws_gen_sle_bck_system.pdf
  def test_inverse
    # RMtx3#getInverse
    m0 = RMtx3.new( 1, 0, -2,
                    4, 1,  0,
                    1, 1,  7 )

    m0inv = RMtx3.new(  7, -2,  2,
                      -28,  9, -8,
                        3, -1,  1 )
    m1 =  m0.getInverse
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0inv.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end

    # RMtx3#invert!
    m2 = RMtx3.new( 25,  5, 1,
                    64,  8, 1,
                   144, 12, 1 )

    m2inv = RMtx3.new(  -4,   7,  -3,
                        80,-119,  39,
                      -384, 420,-120 )
    m2inv *= -1.0 / 84.0

    m2.invert!

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m2inv.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationX
    m0 = RMtx3.new( 1.0, 0.0,              0.0,
                    0.0, Math::sqrt(2)/2, -Math::sqrt(2)/2,
                    0.0, Math::sqrt(2)/2,  Math::sqrt(2)/2 )
    m1 = RMtx3.new.rotationX( Math::PI/4.0 )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end


    m2 = RMtx3.new( 1.0, 0.0,              0.0,
                    0.0, 0.5,             -Math::sqrt(3)/2,
                    0.0, Math::sqrt(3)/2,  0.5 );
    m3 = RMtx3.new.rotationX( Math::PI/3.0 )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationY
    m0 = RMtx3.new(  Math::sqrt(2)/2, 0.0, Math::sqrt(2)/2,
                     0.0,             1.0, 0.0,
                    -Math::sqrt(2)/2, 0.0, Math::sqrt(2)/2 )
    m1 = RMtx3.new.rotationY( Math::PI/4.0 )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end

    m2 = RMtx3.new(  0.5,             0.0, Math::sqrt(3)/2,
                     0.0,             1.0, 0.0,
                    -Math::sqrt(3)/2, 0.0, 0.5 )
    m3 = RMtx3.new.rotationY( Math::PI/3.0 )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationZ
    m0 = RMtx3.new(  Math::sqrt(2)/2, -Math::sqrt(2)/2, 0.0,
                     Math::sqrt(2)/2,  Math::sqrt(2)/2, 0.0,
                     0.0,              0.0,             1.0 )
    m1 = RMtx3.new.rotationZ( Math::PI/4.0 )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end

    m2 = RMtx3.new(  0.5,             -Math::sqrt(3)/2, 0.0,
                     Math::sqrt(3)/2,  0.5,             0.0,
                     0.0,              0.0,             1.0 )
    m3 = RMtx3.new.rotationZ( Math::PI/3.0 )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationAxis
    m0 = RMtx3.new(  0.5,             -Math::sqrt(3)/2, 0.0,
                     Math::sqrt(3)/2,  0.5,             0.0,
                     0.0,              0.0,             1.0 )
    m1 = RMtx3.new.rotationAxis( RVec3.new(0,0,1), Math::PI/3.0 )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end
  end

  def test_rotationQuaternion
    q = RQuat.new.rotationAxis( RVec3.new(0,0,1), Math::PI/3.0 )
    m0 = RMtx3.new(  0.5,             -Math::sqrt(3)/2, 0.0,
                     Math::sqrt(3)/2,  0.5,             0.0,
                     0.0,              0.0,             1.0 )
    m1 = RMtx3.new.rotationQuaternion( q )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end
  end

  def test_scaling
    m0 = RMtx3.new( 10.0,  0.0,  0.0,
                     0.0, 20.0,  0.0,
                     0.0,  0.0, 30.0 )
    m1 = RMtx3.new.scaling( 10.0, 20.0, 30.0 )
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0.getElement(r,c), m1.getElement(r,c), @tolerance )
      end
    end
  end

  def test_unary_operators
    # RMtx3#+@
    m0 = RMtx3.new( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    m1 = RMtx3.new( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    m2 = +m0

    assert_same( m0, m2 )
    assert_not_same( m1, m2 )

    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( 3*r+c, m2.getElement(r,c), @tolerance )
      end
    end

    # RMtx3#-@
    m2 = -m0
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0.getElement(r,c), -m2.getElement(r,c), @tolerance )
      end
    end
  end

  def test_binary_plus
    m0 = RMtx3.new( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    m1 = RMtx3.new( 9,10,11,12,13,14,15,16,17 )
    m2 = RMtx3.new( 9,11,13,15,17,19,21,23,25 )

    # RMtx3#+
    m3 = m0 + m1
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end

    # RMtx3#add!
    m0.add!( m1 )
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m2.getElement(r,c), m0.getElement(r,c), @tolerance )
      end
    end
  end

  def test_binary_minus
    m0 = RMtx3.new( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    m1 = RMtx3.new( 9,10,11,12,13,14,15,16,17 )
    m2 = RMtx3.new(-9,-9,-9,-9,-9,-9,-9,-9,-9 )

    # RMtx3#-
    m3 = m0 - m1
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m2.getElement(r,c), m3.getElement(r,c), @tolerance )
      end
    end

    # RMtx3#sub!
    m0.sub!( m1 )
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m2.getElement(r,c), m0.getElement(r,c), @tolerance )
      end
    end
  end

  def test_binary_mult
    m0 = RMtx3.new( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    m1 = RMtx3.new( 9,10,11,12,13,14,15,16,17 )
    m0x1 = RMtx3.new( 42, 45, 48, 150, 162, 174, 258, 279, 300 )
    m1x0 = RMtx3.new( 96, 126, 156, 123, 162, 201, 150, 198, 246 )

    # RMtx3#*
    m2 = m0 * m1
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0x1.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end

    m2 = m1 * m0
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m1x0.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end

    # RMtx3#mul!
    m2 = RMtx3.new( m0 )
    m2.mul!( m1 )
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m0x1.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end

    m2 = RMtx3.new( m1 )
    m2.mul!( m0 )
    for r in 0...3 do
      for c in 0...3 do
        assert_in_delta( m1x0.getElement(r,c), m2.getElement(r,c), @tolerance )
      end
    end
  end

  def test_equality_operators
    m0 = RMtx3.new( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    m1 = RMtx3.new( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    m2 = RMtx3.new( 9,10,11,12,13,14,15,16,17 )

    assert( m0 == m1 )
    assert( m0 != m2 )
  end

end
