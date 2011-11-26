class TC_RQuat < Test::Unit::TestCase
  def setup
    @tolerance = RMath::TOLERANCE
    @zero = RQuat.new( 0, 0, 0, 0 )
  end

  def teardown
  end

  def test_initialize
    q0 = nil
    assert_nothing_raised{ q0 = RQuat.new }
    assert_in_delta( 0, q0.x, @tolerance )
    assert_in_delta( 0, q0.y, @tolerance )
    assert_in_delta( 0, q0.z, @tolerance )
    assert_in_delta( 0, q0.w, @tolerance )

    q1 = nil
    assert_nothing_raised{ q1 = RQuat.new( 1, 2, 3, 4 ) }
    assert_in_delta( 1, q1.x, @tolerance )
    assert_in_delta( 2, q1.y, @tolerance )
    assert_in_delta( 3, q1.z, @tolerance )
    assert_in_delta( 4, q1.w, @tolerance )

    q2 = nil
    assert_nothing_raised{ q2 = RQuat.new( q1 ) }
    assert_in_delta( 1, q2.x, @tolerance )
    assert_in_delta( 2, q2.y, @tolerance )
    assert_in_delta( 3, q2.z, @tolerance )
    assert_in_delta( 4, q2.w, @tolerance )
  end

  def test_to_s
    assert_respond_to( @zero, :to_s )
  end

  def test_coerce
    assert_respond_to( @zero, :coerce )
  end

  def test_setElements
    q = RQuat.new
    q.setElements( 1, 2, 3, 4 )
    assert_in_delta( 1, q.x, @tolerance )
    assert_in_delta( 2, q.y, @tolerance )
    assert_in_delta( 3, q.z, @tolerance )
    assert_in_delta( 4, q.w, @tolerance )
  end

  def test_setElement
    q = RQuat.new

    # x=
    q.x = 1
    assert_in_delta( 1, q.x, @tolerance )
    q[0] = 2
    assert_in_delta( 2, q.x, @tolerance )

    # y=
    q.y = 1
    assert_in_delta( 1, q.y, @tolerance )
    q[1] = 2
    assert_in_delta( 2, q.y, @tolerance )

    # z=
    q.z = 1
    assert_in_delta( 1, q.z, @tolerance )
    q[2] = 2
    assert_in_delta( 2, q.z, @tolerance )

    # w=
    q.w = 1
    assert_in_delta( 1, q.w, @tolerance )
    q[3] = 2
    assert_in_delta( 2, q.w, @tolerance )

    # xyz=
    v3 = RVec3.new( 4, 5, 6 )
    q.xyz = v3
    assert_in_delta( 4, q.x, @tolerance )
    assert_in_delta( 5, q.y, @tolerance )
    assert_in_delta( 6, q.z, @tolerance )

    v3 = RVec3.new( 7, 8, 9 )
    q.xyz = v3
    assert_in_delta( 7, q.x, @tolerance )
    assert_in_delta( 8, q.y, @tolerance )
    assert_in_delta( 9, q.z, @tolerance )
  end

  def test_getElement
    q = RQuat.new(1,2,3,4)
    assert_in_delta( 1, q[0], @tolerance )
    assert_in_delta( 2, q[1], @tolerance )
    assert_in_delta( 3, q[2], @tolerance )
    assert_in_delta( 4, q[3], @tolerance )

    assert_in_delta( 1, q.x, @tolerance )
    assert_in_delta( 2, q.y, @tolerance )
    assert_in_delta( 3, q.z, @tolerance )
    assert_in_delta( 4, q.w, @tolerance )

    # RQuat#getXYZ, RQuat#xyz
    v3 = q.xyz
    assert_kind_of( RVec3, v3 )
    assert_in_delta( 1, v3.x, @tolerance )
    assert_in_delta( 2, v3.y, @tolerance )
    assert_in_delta( 3, v3.z, @tolerance )

    v3 = q.xyz
    assert_kind_of( RVec3, v3 )
    assert_in_delta( 1, v3.x, @tolerance )
    assert_in_delta( 2, v3.y, @tolerance )
    assert_in_delta( 3, v3.z, @tolerance )
  end

  def test_getLength
    len_sq = 1.0*1.0 + 2.0*2.0 + 3.0*3.0 + 4.0*4.0
    len = Math.sqrt( len_sq )

    q = RQuat.new( 1, 2, 3, 4 )
    assert_in_delta( len_sq, q.getLengthSq, @tolerance )
    assert_in_delta( len   , q.getLength  , @tolerance )
  end

  def test_setIdentity
    q = RQuat.new.setIdentity
    assert_in_delta( 0, q.x, @tolerance )
    assert_in_delta( 0, q.y, @tolerance )
    assert_in_delta( 0, q.z, @tolerance )
    assert_in_delta( 1, q.w, @tolerance )
  end

  def test_conjugate
    q0 = RQuat.new( 1, 2, 3, 4 )

    q1 = q0.getConjugated
    assert_in_delta( -1, q1.x, @tolerance )
    assert_in_delta( -2, q1.y, @tolerance )
    assert_in_delta( -3, q1.z, @tolerance )
    assert_in_delta(  4, q1.w, @tolerance )

    q0.conjugate!
    assert_in_delta( -1, q0.x, @tolerance )
    assert_in_delta( -2, q0.y, @tolerance )
    assert_in_delta( -3, q0.z, @tolerance )
    assert_in_delta(  4, q0.w, @tolerance )
  end

  def test_invert
    qa = RQuat.new( 1,0,0,  3 )
    qb = RQuat.new( 5,1,-2, 0 )
    qc = RQuat.new.rotationAxis( RVec3.new(0,0,1), Math::PI/4.0 )

    qai = qa.getInverse
    qi = qa * qai

    assert_in_delta( 0, qi.x, @tolerance )
    assert_in_delta( 0, qi.y, @tolerance )
    assert_in_delta( 0, qi.z, @tolerance )
    assert_in_delta( 1, qi.w, @tolerance )

    qbi = qb.getInverse
    qi = qbi * qb
    assert_in_delta( 0, qi.x, @tolerance )
    assert_in_delta( 0, qi.y, @tolerance )
    assert_in_delta( 0, qi.z, @tolerance )
    assert_in_delta( 1, qi.w, @tolerance )

    qci = RQuat.new( qc )
    qci.invert!

    qr = qci * qc
    assert_in_delta( 0, qr.x, @tolerance )
    assert_in_delta( 0, qr.y, @tolerance )
    assert_in_delta( 0, qr.z, @tolerance )
    assert_in_delta( 1, qr.w, @tolerance )
  end

  def test_normalize
    len_sq = 1.0*1.0 + 2.0*2.0 + 3.0*3.0 + 4.0*4.0
    len = Math.sqrt( len_sq )
    x = 1.0 / len
    y = 2.0 / len
    z = 3.0 / len
    w = 4.0 / len
    q = RQuat.new( 1, 2, 3, 4 )
    # getNormalized
    q0 = q.getNormalized
    assert_in_delta( x, q0.x, @tolerance )
    assert_in_delta( y, q0.y, @tolerance )
    assert_in_delta( z, q0.z, @tolerance )
    assert_in_delta( w, q0.w, @tolerance )

    # normalize!
    q.normalize!
    assert_in_delta( x, q.x, @tolerance )
    assert_in_delta( y, q.y, @tolerance )
    assert_in_delta( z, q.z, @tolerance )
    assert_in_delta( w, q.w, @tolerance )
  end

  def test_unary_operators
    q = RQuat.new( 1, 2, 3, 4 )

    # RQuat#+@
    qp = +q
    assert_in_delta( 1, qp.x, @tolerance )
    assert_in_delta( 2, qp.y, @tolerance )
    assert_in_delta( 3, qp.z, @tolerance )
    assert_in_delta( 4, qp.w, @tolerance )

    # RQuat#-@
    qm = -q
    assert_in_delta( -1, qm.x, @tolerance )
    assert_in_delta( -2, qm.y, @tolerance )
    assert_in_delta( -3, qm.z, @tolerance )
    assert_in_delta( -4, qm.w, @tolerance )
  end

  def test_plus_operations
    q0 = RQuat.new( 1, 1, 1, 1 )
    q1 = RQuat.new( 2, 2, 2, 2 )

    # RQuat#+
    qr = q0 + q1
    assert_in_delta( 3, qr.x, @tolerance )
    assert_in_delta( 3, qr.y, @tolerance )
    assert_in_delta( 3, qr.z, @tolerance )
    assert_in_delta( 3, qr.w, @tolerance )

    # RQuat#add!
    q0.add!( q1 )
    assert_in_delta( 3, q0.x, @tolerance )
    assert_in_delta( 3, q0.y, @tolerance )
    assert_in_delta( 3, q0.z, @tolerance )
    assert_in_delta( 3, q0.w, @tolerance )

    assert_raises( TypeError ) { q0 + 1.0 }
    assert_raises( TypeError ) { 1.0 + q0 }
  end

  def test_minus_operations
    q0 = RQuat.new( 1, 1, 1, 1 )
    q1 = RQuat.new( 2, 2, 2, 2 )

    # RQuat#-
    qr = q0 - q1
    assert_in_delta( -1, qr.x, @tolerance )
    assert_in_delta( -1, qr.y, @tolerance )
    assert_in_delta( -1, qr.z, @tolerance )
    assert_in_delta( -1, qr.w, @tolerance )

    # RQuat#sub!
    q0.sub!( q1 )
    assert_in_delta( -1, q0.x, @tolerance )
    assert_in_delta( -1, q0.y, @tolerance )
    assert_in_delta( -1, q0.z, @tolerance )
    assert_in_delta( -1, q0.w, @tolerance )

    assert_raises( TypeError ) { q0 - 1.0 }
    assert_raises( TypeError ) { 1.0 - q0 }
  end

  def test_mult_operations
    q0 = RQuat.new( 1, 1, 1, 1 )

    qr = q0 * 2.0
    assert_in_delta( 2.0, qr.x, @tolerance )
    assert_in_delta( 2.0, qr.y, @tolerance )
    assert_in_delta( 2.0, qr.z, @tolerance )
    assert_in_delta( 2.0, qr.w, @tolerance )

    qr = 2.0 * q0
    assert_in_delta( 2.0, qr.x, @tolerance )
    assert_in_delta( 2.0, qr.y, @tolerance )
    assert_in_delta( 2.0, qr.z, @tolerance )
    assert_in_delta( 2.0, qr.w, @tolerance )

    q0.mul!( 2.0 )
    assert_in_delta( 2.0, q0.x, @tolerance )
    assert_in_delta( 2.0, q0.y, @tolerance )
    assert_in_delta( 2.0, q0.z, @tolerance )
    assert_in_delta( 2.0, q0.w, @tolerance )

    # http://en.wikipedia.org/wiki/Quaternions
    qa = RQuat.new( 1,0,0,  3 )
    qb = RQuat.new( 5,1,-2, 0 )
    qab = RQuat.new( 15,5,-5, -5 )
    qba = RQuat.new( 15,1,-7, -5 )

    qr =  qa * qb
    assert_in_delta( qab.x, qr.x, @tolerance )
    assert_in_delta( qab.y, qr.y, @tolerance )
    assert_in_delta( qab.z, qr.z, @tolerance )
    assert_in_delta( qab.w, qr.w, @tolerance )

    qr =  qb * qa
    assert_in_delta( qba.x, qr.x, @tolerance )
    assert_in_delta( qba.y, qr.y, @tolerance )
    assert_in_delta( qba.z, qr.z, @tolerance )
    assert_in_delta( qba.w, qr.w, @tolerance )

    qa.mul!( qb )
    assert_in_delta( qab.x, qa.x, @tolerance )
    assert_in_delta( qab.y, qa.y, @tolerance )
    assert_in_delta( qab.z, qa.z, @tolerance )
    assert_in_delta( qab.w, qa.w, @tolerance )
  end

  def test_equality_operations
    v = RQuat.new
    assert( v == @zero )

    v0 = RQuat.new(1,2,3,4)
    assert( v != v0 )
  end

  def test_rotationMatrix
    rad = Math::PI/3
    m0 = RMtx4.new.rotationAxis( RVec3.new(0,0,1), rad )
    q0 = RQuat.new( 0, 0, Math::sin(rad/2), Math::cos(rad/2) )
    q1 = RQuat.new.rotationMatrix( m0 )
    assert_in_delta( q0.x, q1.x, @tolerance )
    assert_in_delta( q0.y, q1.y, @tolerance )
    assert_in_delta( q0.z, q1.z, @tolerance )
    assert_in_delta( q0.w, q1.w, @tolerance )
  end

  def test_rotationAxis
    rad = Math::PI/3
    q0 = RQuat.new( 0, 0, Math::sin(rad/2), Math::cos(rad/2) )
    q1 = RQuat.new.rotationAxis( RVec3.new(0,0,1), rad )
    assert_in_delta( q0.x, q1.x, @tolerance )
    assert_in_delta( q0.y, q1.y, @tolerance )
    assert_in_delta( q0.z, q1.z, @tolerance )
    assert_in_delta( q0.w, q1.w, @tolerance )
  end

  def test_toAxisAngle
    rad = Math::PI/3
    q0 = RQuat.new( 0, 0, Math::sin(rad/2), Math::cos(rad/2) )
    axis, angle = q0.toAxisAngle

    assert_kind_of( RVec3, axis )
    assert_in_delta( 0, axis.x, @tolerance )
    assert_in_delta( 0, axis.y, @tolerance )
    assert_in_delta( 1, axis.z, @tolerance )
    assert_in_delta( rad, angle, @tolerance )
  end

  def test_dot
    q0 = RQuat.new( 1, 1, 1, 1 )
    q1 = RQuat.new( 2, 2, 2, 2 )

    assert_in_delta( 8.0, RQuat.dot(q0, q1), @tolerance )
  end

  def test_slerp
    qs = RQuat.new.rotationAxis( RVec3.new(0,0,1), 1.0*Math::PI/6 )
    qe = RQuat.new.rotationAxis( RVec3.new(0,0,1), 5.0*Math::PI/6 )

    q = RQuat.slerp( qs, qe, 0.0 )
    assert_in_delta( qs.x, q.x, @tolerance )
    assert_in_delta( qs.y, q.y, @tolerance )
    assert_in_delta( qs.z, q.z, @tolerance )
    assert_in_delta( qs.w, q.w, @tolerance )

    q = RQuat.slerp( qs, qe, 0.5 )
    qr = RQuat.new( 0,0,Math::sin((Math::PI/2)/2), Math::cos((Math::PI/2)/2) )
    assert_in_delta( qr.x, q.x, @tolerance )
    assert_in_delta( qr.y, q.y, @tolerance )
    assert_in_delta( qr.z, q.z, @tolerance )
    assert_in_delta( qr.w, q.w, @tolerance )

    q = RQuat.slerp( qs, qe, 1.0 )
    assert_in_delta( qe.x, q.x, @tolerance )
    assert_in_delta( qe.y, q.y, @tolerance )
    assert_in_delta( qe.z, q.z, @tolerance )
    assert_in_delta( qe.w, q.w, @tolerance )
  end

end
