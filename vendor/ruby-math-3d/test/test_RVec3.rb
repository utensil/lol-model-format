class TC_RVec3 < Test::Unit::TestCase
  def setup
    @tolerance = RMath::TOLERANCE
    @zero = RVec3.new( 0, 0, 0 )
    @ax   = RVec3.new( 1, 0, 0 )
    @ay   = RVec3.new( 0, 1, 0 )
    @az   = RVec3.new( 0, 0, 1 )
  end

  def teardown
  end

  def test_initialize
    v0 = nil
    assert_nothing_raised{ v0 = RVec3.new }
    assert_in_delta( 0, v0.x, @tolerance )
    assert_in_delta( 0, v0.y, @tolerance )
    assert_in_delta( 0, v0.z, @tolerance )

    v1 = nil
    assert_nothing_raised{ v1 = RVec3.new( 1, 2, 3 ) }
    assert_in_delta( 1, v1.x, @tolerance )
    assert_in_delta( 2, v1.y, @tolerance )
    assert_in_delta( 3, v1.z, @tolerance )

    v2 = nil
    assert_nothing_raised{ v2 = RVec3.new( v1 ) }
    assert_in_delta( 1, v2.x, @tolerance )
    assert_in_delta( 2, v2.y, @tolerance )
    assert_in_delta( 3, v2.z, @tolerance )
  end

  def test_to_s
    assert_respond_to( @zero, :to_s )
  end

  def test_coerce
    assert_respond_to( @zero, :coerce )
  end

  def test_setElements
    v = RVec3.new
    v.setElements( 1, 2, 3 )
    assert_in_delta( 1, v.x, @tolerance )
    assert_in_delta( 2, v.y, @tolerance )
    assert_in_delta( 3, v.z, @tolerance )
  end

  def test_setElement
    v = RVec3.new

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
  end

  def test_getElement
    assert_in_delta( 1, @ax[0], @tolerance )
    assert_in_delta( 1, @ay[1], @tolerance )
    assert_in_delta( 1, @az[2], @tolerance )

    assert_in_delta( 1, @ax.x, @tolerance )
    assert_in_delta( 1, @ay.y, @tolerance )
    assert_in_delta( 1, @az.z, @tolerance )
  end

  def test_getLength
    len_sq = 1.0*1.0 + 2.0*2.0 + 3.0*3.0 # == 14.0
    len = Math.sqrt( len_sq ) # == 3.3166247903554

    v = RVec3.new( 1, 2, 3 )
    assert_in_delta( len_sq, v.getLengthSq, @tolerance )
    assert_in_delta( len   , v.getLength  , @tolerance )
  end

  def test_normalize
    len_sq = 1.0*1.0 + 2.0*2.0 + 3.0*3.0 # == 14.0
    len = Math.sqrt( len_sq ) # == 3.3166247903554
    x = 1.0 / len
    y = 2.0 / len
    z = 3.0 / len
    v = RVec3.new( 1, 2, 3 )
    # getNormalized
    v0 = v.getNormalized
    assert_in_delta( x, v0.x, @tolerance )
    assert_in_delta( y, v0.y, @tolerance )
    assert_in_delta( z, v0.z, @tolerance )

    # normalize!
    v.normalize!
    assert_in_delta( x, v.x, @tolerance )
    assert_in_delta( y, v.y, @tolerance )
    assert_in_delta( z, v.z, @tolerance )
  end

  def test_unary_operators
    v = RVec3.new( 1, 2, 3 )

    # RVec3#+@
    vp = +v
    assert_in_delta( 1, vp.x, @tolerance )
    assert_in_delta( 2, vp.y, @tolerance )
    assert_in_delta( 3, vp.z, @tolerance )

    # RVec3#-@
    vm = -v
    assert_in_delta( -1, vm.x, @tolerance )
    assert_in_delta( -2, vm.y, @tolerance )
    assert_in_delta( -3, vm.z, @tolerance )
  end

  def test_plus_operations
    v0 = RVec3.new( 1, 1, 1 )
    v1 = RVec3.new( 2, 2, 2 )

    # RVec3#+
    vr = v0 + v1
    assert_in_delta( 3, vr.x, @tolerance )
    assert_in_delta( 3, vr.y, @tolerance )
    assert_in_delta( 3, vr.z, @tolerance )

    # RVec3#add!
    v0.add!( v1 )
    assert_in_delta( 3, v0.x, @tolerance )
    assert_in_delta( 3, v0.y, @tolerance )
    assert_in_delta( 3, v0.z, @tolerance )

    assert_raises( TypeError ) { v0 + 1.0 }
    assert_raises( TypeError ) { 1.0 + v0 }
  end

  def test_minus_operations
    v0 = RVec3.new( 1, 1, 1 )
    v1 = RVec3.new( 2, 2, 2 )

    # RVec3#-
    vr = v0 - v1
    assert_in_delta( -1, vr.x, @tolerance )
    assert_in_delta( -1, vr.y, @tolerance )
    assert_in_delta( -1, vr.z, @tolerance )

    # RVec3#sub!
    v0.sub!( v1 )
    assert_in_delta( -1, v0.x, @tolerance )
    assert_in_delta( -1, v0.y, @tolerance )
    assert_in_delta( -1, v0.z, @tolerance )

    assert_raises( TypeError ) { v0 - 1.0 }
    assert_raises( TypeError ) { 1.0 - v0 }
  end

  def test_mult_operations
    v0 = RVec3.new( 1, 1, 1 )

    vr = v0 * 2.0
    assert_in_delta( 2.0, vr.x, @tolerance )
    assert_in_delta( 2.0, vr.y, @tolerance )
    assert_in_delta( 2.0, vr.z, @tolerance )

    vr = 2.0 * v0
    assert_in_delta( 2.0, vr.x, @tolerance )
    assert_in_delta( 2.0, vr.y, @tolerance )
    assert_in_delta( 2.0, vr.z, @tolerance )

    v0.mul!( 2.0 )
    assert_in_delta( 2.0, v0.x, @tolerance )
    assert_in_delta( 2.0, v0.y, @tolerance )
    assert_in_delta( 2.0, v0.z, @tolerance )

    assert_raises( TypeError ) { v0 * @zero }
  end

  def test_equality_operations
    v = RVec3.new
    assert( v == @zero )
    assert( v != @ax )
  end

  def test_dot
    v0 = RVec3.new( 1, 1, 1 )
    v1 = RVec3.new( 2, 2, 2 )
    assert_in_delta( 6.0, RVec3.dot(v0, v1), @tolerance )
    assert_in_delta( 0.0, RVec3.dot(@ax, @ay), @tolerance )
#    assert_raises( TypeError ) { RVec3.dot(@ax, 1.0) }
#    assert_raises( TypeError ) { RVec3.dot(1.0, @ax) }
  end

  def test_cross
    vr = RVec3.cross( @ax, @ay )
    assert_in_delta( @az.x, vr.x, @tolerance )
    assert_in_delta( @az.y, vr.y, @tolerance )
    assert_in_delta( @az.z, vr.z, @tolerance )
  end

  def test_transform
    m = RMtx4.new.rotationX( Math::PI/4.0 )
    va = RVec3.new( 0.0, -Math.sqrt(2)/2, Math.sqrt(2)/2 )

    vr = @az.transform( m )
    assert_kind_of( RVec4, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )

    m = RMtx4.new.translation( 1.0, 1.0, 1.0 )
    va = RVec3.new( 1.0, 1.0, 2.0 )

    vr = @az.transform( m )
    assert_kind_of( RVec4, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )
  end

  def test_transformCoord
    m = RMtx4.new.rotationX( Math::PI/4.0 )
    va = RVec3.new( 0.0, -Math.sqrt(2)/2, Math.sqrt(2)/2 )

    vr = @az.transformCoord( m )
    assert_kind_of( RVec3, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )

    vr = RVec3.new( @az )
    vr.transformCoord!( m )
    assert_kind_of( RVec3, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )

    m = RMtx4.new.translation( 1.0, 1.0, 1.0 )
    va = RVec3.new( 1.0, 1.0, 2.0 )

    vr = @az.transformCoord( m )
    assert_kind_of( RVec3, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )
  end

  def test_transformNormal
    m = RMtx4.new.rotationX( Math::PI/4.0 )
    va = RVec3.new( 0.0, -Math.sqrt(2)/2, Math.sqrt(2)/2 )

    vr = @az.transformNormal( m )
    assert_kind_of( RVec3, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )

    vr = RVec3.new( @az )
    vr.transformNormal!( m )
    assert_kind_of( RVec3, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )

    m = RMtx4.new.translation( 1.0, 1.0, 1.0 )
    va = RVec3.new( 1.0, 1.0, 2.0 )

    vr = @az.transformNormal( m )
    assert_kind_of( RVec3, vr )
    assert_in_delta( @az.x, vr.x, @tolerance )
    assert_in_delta( @az.y, vr.y, @tolerance )
    assert_in_delta( @az.z, vr.z, @tolerance )
  end

  def test_transformRS
    m = RMtx3.new.rotationX( Math::PI/4.0 )
    va = RVec3.new( 0.0, -Math.sqrt(2)/2, Math.sqrt(2)/2 )

    vr = @az.transformRS( m )
    assert_kind_of( RVec3, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )

    vr = RVec3.new( @az )
    vr.transformRS!( m )
    assert_kind_of( RVec3, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )

    m = RMtx3.new.scaling( 2.0, 2.0, 2.0 )

    vr = @az.transformRS( m )
    va = RVec3.new( 0, 0, 2.0 )

    assert_kind_of( RVec3, vr )
    assert_in_delta( va.x, vr.x, @tolerance )
    assert_in_delta( va.y, vr.y, @tolerance )
    assert_in_delta( va.z, vr.z, @tolerance )
  end
end
