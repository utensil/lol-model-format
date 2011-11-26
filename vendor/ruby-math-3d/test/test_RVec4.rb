class TC_RVec4 < Test::Unit::TestCase
  def setup
    @tolerance = RMath::TOLERANCE
    @zero = RVec4.new( 0, 0, 0, 0 )
    @ax   = RVec3.new( 1, 0, 0 )
    @ay   = RVec3.new( 0, 1, 0 )
    @az   = RVec3.new( 0, 0, 1 )
  end

  def teardown
  end

  def test_initialize
    v0 = nil
    assert_nothing_raised{ v0 = RVec4.new }
    assert_in_delta( 0, v0.x, @tolerance )
    assert_in_delta( 0, v0.y, @tolerance )
    assert_in_delta( 0, v0.z, @tolerance )
    assert_in_delta( 0, v0.w, @tolerance )

    v1 = nil
    assert_nothing_raised{ v1 = RVec4.new( 1, 2, 3, 4 ) }
    assert_in_delta( 1, v1.x, @tolerance )
    assert_in_delta( 2, v1.y, @tolerance )
    assert_in_delta( 3, v1.z, @tolerance )
    assert_in_delta( 4, v1.w, @tolerance )

    v2 = nil
    assert_nothing_raised{ v2 = RVec4.new( v1 ) }
    assert_in_delta( 1, v2.x, @tolerance )
    assert_in_delta( 2, v2.y, @tolerance )
    assert_in_delta( 3, v2.z, @tolerance )
    assert_in_delta( 4, v2.w, @tolerance )
  end

  def test_to_s
    assert_respond_to( @zero, :to_s )
  end

  def test_coerce
    assert_respond_to( @zero, :coerce )
  end

  def test_setElements
    v = RVec4.new
    v.setElements( 1, 2, 3, 4 )
    assert_in_delta( 1, v.x, @tolerance )
    assert_in_delta( 2, v.y, @tolerance )
    assert_in_delta( 3, v.z, @tolerance )
    assert_in_delta( 4, v.w, @tolerance )
  end

  def test_setElement
    v = RVec4.new

    # x=
    v.x = 1
    assert_in_delta( 1, v.x, @tolerance )
    v[0] = 2
    assert_in_delta( 2, v.x, @tolerance )

    # y=
    v.y = 1
    assert_in_delta( 1, v.y, @tolerance )
    v[1] = 2
    assert_in_delta( 2, v.y, @tolerance )

    # z=
    v.z = 1
    assert_in_delta( 1, v.z, @tolerance )
    v[2] = 2
    assert_in_delta( 2, v.z, @tolerance )

    # w=
    v.w = 1
    assert_in_delta( 1, v.w, @tolerance )
    v[3] = 2
    assert_in_delta( 2, v.w, @tolerance )

    # xyz=
    v3 = RVec3.new( 4, 5, 6 )
    v.xyz = v3
    assert_in_delta( 4, v.x, @tolerance )
    assert_in_delta( 5, v.y, @tolerance )
    assert_in_delta( 6, v.z, @tolerance )

    v3 = RVec3.new( 7, 8, 9 )
    v.xyz = v3
    assert_in_delta( 7, v.x, @tolerance )
    assert_in_delta( 8, v.y, @tolerance )
    assert_in_delta( 9, v.z, @tolerance )
  end

  def test_getElement
    axis = RVec4.new(1,2,3,4)
    assert_in_delta( 1, axis[0], @tolerance )
    assert_in_delta( 2, axis[1], @tolerance )
    assert_in_delta( 3, axis[2], @tolerance )
    assert_in_delta( 4, axis[3], @tolerance )

    assert_in_delta( 1, axis.x, @tolerance )
    assert_in_delta( 2, axis.y, @tolerance )
    assert_in_delta( 3, axis.z, @tolerance )
    assert_in_delta( 4, axis.w, @tolerance )

    # RVec4#xyz
    v3 = axis.xyz
    assert_kind_of( RVec3, v3 )
    assert_in_delta( 1, v3.x, @tolerance )
    assert_in_delta( 2, v3.y, @tolerance )
    assert_in_delta( 3, v3.z, @tolerance )

    assert_kind_of( RVec3, v3 )
    assert_in_delta( 1, v3[0], @tolerance )
    assert_in_delta( 2, v3[1], @tolerance )
    assert_in_delta( 3, v3[2], @tolerance )
  end

  def test_getLength
    len_sq = 1.0*1.0 + 2.0*2.0 + 3.0*3.0 + 4.0*4.0
    len = Math.sqrt( len_sq )

    v = RVec4.new( 1, 2, 3, 4 )
    assert_in_delta( len_sq, v.getLengthSq, @tolerance )
    assert_in_delta( len   , v.getLength  , @tolerance )
  end

  def test_normalize
    len_sq = 1.0*1.0 + 2.0*2.0 + 3.0*3.0 + 4.0*4.0
    len = Math.sqrt( len_sq )
    x = 1.0 / len
    y = 2.0 / len
    z = 3.0 / len
    w = 4.0 / len
    v = RVec4.new( 1, 2, 3, 4 )
    # getNormalized
    v0 = v.getNormalized
    assert_in_delta( x, v0.x, @tolerance )
    assert_in_delta( y, v0.y, @tolerance )
    assert_in_delta( z, v0.z, @tolerance )
    assert_in_delta( w, v0.w, @tolerance )

    # normalize!
    v.normalize!
    assert_in_delta( x, v.x, @tolerance )
    assert_in_delta( y, v.y, @tolerance )
    assert_in_delta( z, v.z, @tolerance )
    assert_in_delta( w, v.w, @tolerance )
  end

  def test_unary_operators
    v = RVec4.new( 1, 2, 3, 4 )

    # RVec4#+@
    vp = +v
    assert_in_delta( 1, vp.x, @tolerance )
    assert_in_delta( 2, vp.y, @tolerance )
    assert_in_delta( 3, vp.z, @tolerance )
    assert_in_delta( 4, vp.w, @tolerance )

    # RVec4#-@
    vm = -v
    assert_in_delta( -1, vm.x, @tolerance )
    assert_in_delta( -2, vm.y, @tolerance )
    assert_in_delta( -3, vm.z, @tolerance )
    assert_in_delta( -4, vm.w, @tolerance )
  end

  def test_plus_operations
    v0 = RVec4.new( 1, 1, 1, 1 )
    v1 = RVec4.new( 2, 2, 2, 2 )

    # RVec4#+
    vr = v0 + v1
    assert_in_delta( 3, vr.x, @tolerance )
    assert_in_delta( 3, vr.y, @tolerance )
    assert_in_delta( 3, vr.z, @tolerance )
    assert_in_delta( 3, vr.w, @tolerance )

    # RVec4#add!
    v0.add!( v1 )
    assert_in_delta( 3, v0.x, @tolerance )
    assert_in_delta( 3, v0.y, @tolerance )
    assert_in_delta( 3, v0.z, @tolerance )
    assert_in_delta( 3, v0.w, @tolerance )

    assert_raises( TypeError ) { v0 + 1.0 }
    assert_raises( TypeError ) { 1.0 + v0 }
  end

  def test_minus_operations
    v0 = RVec4.new( 1, 1, 1, 1 )
    v1 = RVec4.new( 2, 2, 2, 2 )

    # RVec4#-
    vr = v0 - v1
    assert_in_delta( -1, vr.x, @tolerance )
    assert_in_delta( -1, vr.y, @tolerance )
    assert_in_delta( -1, vr.z, @tolerance )
    assert_in_delta( -1, vr.w, @tolerance )

    # RVec4#sub!
    v0.sub!( v1 )
    assert_in_delta( -1, v0.x, @tolerance )
    assert_in_delta( -1, v0.y, @tolerance )
    assert_in_delta( -1, v0.z, @tolerance )
    assert_in_delta( -1, v0.w, @tolerance )

    assert_raises( TypeError ) { v0 - 1.0 }
    assert_raises( TypeError ) { 1.0 - v0 }
  end

  def test_mult_operations
    v0 = RVec4.new( 1, 1, 1, 1 )

    vr = v0 * 2.0
    assert_in_delta( 2.0, vr.x, @tolerance )
    assert_in_delta( 2.0, vr.y, @tolerance )
    assert_in_delta( 2.0, vr.z, @tolerance )
    assert_in_delta( 2.0, vr.w, @tolerance )

    vr = 2.0 * v0
    assert_in_delta( 2.0, vr.x, @tolerance )
    assert_in_delta( 2.0, vr.y, @tolerance )
    assert_in_delta( 2.0, vr.z, @tolerance )
    assert_in_delta( 2.0, vr.w, @tolerance )

    v0.mul!( 2.0 )
    assert_in_delta( 2.0, v0.x, @tolerance )
    assert_in_delta( 2.0, v0.y, @tolerance )
    assert_in_delta( 2.0, v0.z, @tolerance )
    assert_in_delta( 2.0, v0.w, @tolerance )

    assert_raises( TypeError ) { v0 * @zero }
  end

  def test_equality_operations
    v = RVec4.new
    assert( v == @zero )

    v0 = RVec4.new(1,2,3,4)
    assert( v != v0 )
  end

  def test_dot
    v0 = RVec4.new( 1, 1, 1, 1 )
    v1 = RVec4.new( 2, 2, 2, 2 )
    ax = RVec4.new( 1, 0, 0, 0 )
    ay = RVec4.new( 0, 1, 0, 0 )

    assert_in_delta( 8.0, RVec4.dot(v0, v1), @tolerance )
    assert_in_delta( 0.0, RVec4.dot(ax, ay), @tolerance )
#     assert_raises( TypeError ) { RVec4.dot(ax, 1.0) }
#     assert_raises( TypeError ) { RVec4.dot(1.0, ax) }
  end

  def test_transform
    m = RMtx4.new.rotationX( Math::PI/4.0 )
    az = RVec4.new( 0.0, 0.0, 1.0, 1.0 )
    va = RVec4.new( 0.0, -Math.sqrt(2)/2, Math.sqrt(2)/2, 1.0 )

    vr = az.transform( m )
    assert_kind_of( RVec4, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )
    assert_in_delta( va.w, vr.w, @tolerance )

    m = RMtx4.new.translation( 1.0, 1.0, 1.0 )
    va = RVec4.new( 1.0, 1.0, 2.0, 1.0 )

    vr = az.transform( m )

    assert_kind_of( RVec4, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )
    assert_in_delta( va.w, vr.w, @tolerance )

    az.transform!( m )

    assert_kind_of( RVec4, vr )
    assert_in_delta( va.x, az.x, @tolerance )
    assert_in_delta( va.y, az.y, @tolerance )
    assert_in_delta( va.z, az.z, @tolerance )
    assert_in_delta( va.w, az.w, @tolerance )
  end

end
