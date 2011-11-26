#include <math.h>
#include <string.h>

#include "RVec3.h"
#include "RVec4.h"
#include "RQuat.h"
#include "RMtx3.h"
#include "RMtx4.h"

/* NOTE : column-major */
#define SET_ELEMENT(out, row, col, val) (out)->e[(col)*4+(row)] = (val)
#define GET_ELEMENT(in, row, col) ((in)->e[(col)*4+(row)])

void
RMtx4SetElement( RMtx4* out, int row, int col, rmReal e )
{
    SET_ELEMENT( out, row, col, e );
}

rmReal
RMtx4GetElement( const RMtx4* in, int row, int col )
{
    return GET_ELEMENT( in, row, col );
}

void
RMtx4GetRow( RVec4* out, const RMtx4* in, int row )
{
    RVec4SetX( out, GET_ELEMENT( in, row, 0 ) );
    RVec4SetY( out, GET_ELEMENT( in, row, 1 ) );
    RVec4SetZ( out, GET_ELEMENT( in, row, 2 ) );
    RVec4SetW( out, GET_ELEMENT( in, row, 3 ) );
}

void
RMtx4GetColumn( RVec4* out, const RMtx4* in, int col )
{
    RVec4SetX( out, GET_ELEMENT( in, 0, col ) );
    RVec4SetY( out, GET_ELEMENT( in, 1, col ) );
    RVec4SetZ( out, GET_ELEMENT( in, 2, col ) );
    RVec4SetW( out, GET_ELEMENT( in, 3, col ) );
}

void
RMtx4SetRow( RMtx4* out, const RVec4* in, int row )
{
    SET_ELEMENT( out, row, 0, RVec4GetElement( in, 0 ) );
    SET_ELEMENT( out, row, 1, RVec4GetElement( in, 1 ) );
    SET_ELEMENT( out, row, 2, RVec4GetElement( in, 2 ) );
    SET_ELEMENT( out, row, 3, RVec4GetElement( in, 3 ) );
}

void
RMtx4SetColumn( RMtx4* out, const RVec4* in, int col )
{
    SET_ELEMENT( out, 0, col, RVec4GetElement( in, 0 ) );
    SET_ELEMENT( out, 1, col, RVec4GetElement( in, 1 ) );
    SET_ELEMENT( out, 2, col, RVec4GetElement( in, 2 ) );
    SET_ELEMENT( out, 3, col, RVec4GetElement( in, 3 ) );
}

void
RMtx4GetUpper3x3( RMtx3* out, const RMtx4* in )
{
    RMtx3SetElements( out,
                      GET_ELEMENT(in,0,0), GET_ELEMENT(in,0,1), GET_ELEMENT(in,0,2),
                      GET_ELEMENT(in,1,0), GET_ELEMENT(in,1,1), GET_ELEMENT(in,1,2),
                      GET_ELEMENT(in,2,0), GET_ELEMENT(in,2,1), GET_ELEMENT(in,2,2) );
}

void
RMtx4SetUpper3x3( RMtx4* out, const RMtx3* in )
{
    SET_ELEMENT( out, 0, 0, RMtx3GetElement( in, 0, 0 ) );
    SET_ELEMENT( out, 0, 1, RMtx3GetElement( in, 0, 1 ) );
    SET_ELEMENT( out, 0, 2, RMtx3GetElement( in, 0, 2 ) );
    SET_ELEMENT( out, 1, 0, RMtx3GetElement( in, 1, 0 ) );
    SET_ELEMENT( out, 1, 1, RMtx3GetElement( in, 1, 1 ) );
    SET_ELEMENT( out, 1, 2, RMtx3GetElement( in, 1, 2 ) );
    SET_ELEMENT( out, 2, 0, RMtx3GetElement( in, 2, 0 ) );
    SET_ELEMENT( out, 2, 1, RMtx3GetElement( in, 2, 1 ) );
    SET_ELEMENT( out, 2, 2, RMtx3GetElement( in, 2, 2 ) );
}

void
RMtx4Copy( RMtx4* out, const RMtx4* in )
{
    memmove( out, in, sizeof(RMtx4) );
}

void
RMtx4SetElements( RMtx4* out,
                  rmReal e00, rmReal e01, rmReal e02, rmReal e03,
                  rmReal e10, rmReal e11, rmReal e12, rmReal e13,
                  rmReal e20, rmReal e21, rmReal e22, rmReal e23,
                  rmReal e30, rmReal e31, rmReal e32, rmReal e33
    )
{
    SET_ELEMENT( out, 0, 0, e00 );
    SET_ELEMENT( out, 0, 1, e01 );
    SET_ELEMENT( out, 0, 2, e02 );
    SET_ELEMENT( out, 0, 3, e03 );

    SET_ELEMENT( out, 1, 0, e10 );
    SET_ELEMENT( out, 1, 1, e11 );
    SET_ELEMENT( out, 1, 2, e12 );
    SET_ELEMENT( out, 1, 3, e13 );

    SET_ELEMENT( out, 2, 0, e20 );
    SET_ELEMENT( out, 2, 1, e21 );
    SET_ELEMENT( out, 2, 2, e22 );
    SET_ELEMENT( out, 2, 3, e23 );

    SET_ELEMENT( out, 3, 0, e30 );
    SET_ELEMENT( out, 3, 1, e31 );
    SET_ELEMENT( out, 3, 2, e32 );
    SET_ELEMENT( out, 3, 3, e33 );
}

void
RMtx4Zero( RMtx4* out )
{
    int row, col;
    for ( row = 0; row < 4; ++row )
        for ( col = 0; col < 4; ++col )
            SET_ELEMENT( out, row, col, 0.0f );
}

void
RMtx4Identity( RMtx4* out )
{
    int row, col;
    for ( row = 0; row < 4; ++row )
        for ( col = 0; col < 4; ++col )
            SET_ELEMENT( out, row, col, (row==col) ? 1.0f : 0.0f );
}

rmReal
RMtx4Determinant( const RMtx4* in )
{
#define I( r, c ) GET_ELEMENT( in, (r), (c) )
#define D( e00,e01,e02, e10,e11,e12, e20,e21,e22 )  \
      ( (e00)*((e11)*(e22)-(e12)*(e21))             \
      - (e01)*((e10)*(e22)-(e12)*(e20))             \
      + (e02)*((e10)*(e21)-(e11)*(e20)) )

    return
        I(0,0) * D( I(1,1),I(1,2),I(1,3), I(2,1),I(2,2),I(2,3), I(3,1),I(3,2),I(3,3) ) -
        I(0,1) * D( I(1,0),I(1,2),I(1,3), I(2,0),I(2,2),I(2,3), I(3,0),I(3,2),I(3,3) ) +
        I(0,2) * D( I(1,0),I(1,1),I(1,3), I(2,0),I(2,1),I(2,3), I(3,0),I(3,1),I(3,3) ) -
        I(0,3) * D( I(1,0),I(1,1),I(1,2), I(2,0),I(2,1),I(2,2), I(3,0),I(3,1),I(3,2) ) ;

#undef I
#undef D
}

void
RMtx4Transpose( RMtx4* out, const RMtx4* in )
{
    int row, col;
    RMtx4 tmp;
    for ( row = 0; row < 4; ++row )
        for ( col = 0; col < 4; ++col )
            SET_ELEMENT( &tmp, row, col, GET_ELEMENT( in, col, row ) );

    RMtx4Copy( out, &tmp );
}

rmReal
RMtx4Inverse( RMtx4* out, const RMtx4* in )
{
#define I( r, c ) GET_ELEMENT( in, (r), (c) )
#define R( r, c ) GET_ELEMENT( &result, (r), (c) )
#define D( e00,e01,e02, e10,e11,e12, e20,e21,e22 )  \
      ( (e00)*((e11)*(e22)-(e12)*(e21))             \
      - (e01)*((e10)*(e22)-(e12)*(e20))             \
      + (e02)*((e10)*(e21)-(e11)*(e20)) )

    RMtx4 result;
    rmReal det;

    SET_ELEMENT( &result, 0, 0,
                 D( I(1,1),I(1,2),I(1,3), I(2,1),I(2,2),I(2,3), I(3,1),I(3,2),I(3,3) ) );

    SET_ELEMENT( &result, 0, 1,
                -D( I(0,1),I(0,2),I(0,3), I(2,1),I(2,2),I(2,3), I(3,1),I(3,2),I(3,3) ) );

    SET_ELEMENT( &result, 0, 2,
                 D( I(0,1),I(0,2),I(0,3), I(1,1),I(1,2),I(1,3), I(3,1),I(3,2),I(3,3) ) );

    SET_ELEMENT( &result, 0, 3,
                -D( I(0,1),I(0,2),I(0,3), I(1,1),I(1,2),I(1,3), I(2,1),I(2,2),I(2,3) ) );

    SET_ELEMENT( &result, 1, 0,
                -D( I(1,0),I(1,2),I(1,3), I(2,0),I(2,2),I(2,3), I(3,0),I(3,2),I(3,3) ) );

    SET_ELEMENT( &result, 1, 1,
                 D( I(0,0),I(0,2),I(0,3), I(2,0),I(2,2),I(2,3), I(3,0),I(3,2),I(3,3) ) );

    SET_ELEMENT( &result, 1, 2,
                -D( I(0,0),I(0,2),I(0,3), I(1,0),I(1,2),I(1,3), I(3,0),I(3,2),I(3,3) ) );

    SET_ELEMENT( &result, 1, 3,
                 D( I(0,0),I(0,2),I(0,3), I(1,0),I(1,2),I(1,3), I(2,0),I(2,2),I(2,3) ) );

    SET_ELEMENT( &result, 2, 0,
                 D( I(1,0),I(1,1),I(1,3), I(2,0),I(2,1),I(2,3), I(3,0),I(3,1),I(3,3) ) );

    SET_ELEMENT( &result, 2, 1,
                -D( I(0,0),I(0,1),I(0,3), I(2,0),I(2,1),I(2,3), I(3,0),I(3,1),I(3,3) ) );

    SET_ELEMENT( &result, 2, 2,
                 D( I(0,0),I(0,1),I(0,3), I(1,0),I(1,1),I(1,3), I(3,0),I(3,1),I(3,3) ) );

    SET_ELEMENT( &result, 2, 3,
                -D( I(0,0),I(0,1),I(0,3), I(1,0),I(1,1),I(1,3), I(2,0),I(2,1),I(2,3) ) );

    SET_ELEMENT( &result, 3, 0,
                -D( I(1,0),I(1,1),I(1,2), I(2,0),I(2,1),I(2,2), I(3,0),I(3,1),I(3,2) ) );

    SET_ELEMENT( &result, 3, 1,
                 D( I(0,0),I(0,1),I(0,2), I(2,0),I(2,1),I(2,2), I(3,0),I(3,1),I(3,2) ) );

    SET_ELEMENT( &result, 3, 2,
                -D( I(0,0),I(0,1),I(0,2), I(1,0),I(1,1),I(1,2), I(3,0),I(3,1),I(3,2) ) );

    SET_ELEMENT( &result, 3, 3,
                 D( I(0,0),I(0,1),I(0,2), I(1,0),I(1,1),I(1,2), I(2,0),I(2,1),I(2,2) ) );

    det = I(0,0) * R(0,0) + I(0,1) * R(1,0) + I(0,2) * R(2,0) + I(0,3) * R(3,0);

    if ( rmFabs(det) < RMATH_TOLERANCE )
        return det;

    RMtx4Scale( out, &result, 1.0f / det );

    return det;

#undef I
#undef R
#undef D
}


void
RMtx4Translation( RMtx4* out, rmReal tx, rmReal ty, rmReal tz )
{
    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 3, tx );
    SET_ELEMENT( out, 1, 3, ty );
    SET_ELEMENT( out, 2, 3, tz );
}

/* http://en.wikipedia.org/wiki/Rotation_representation_%28mathematics%29
   http://en.wikipedia.org/wiki/Rotation_matrix
*/
void
RMtx4RotationX( RMtx4* out, rmReal radian )
{
    rmReal s = rmSin( radian );
    rmReal c = rmCos( radian );

    RMtx4Identity( out );
    SET_ELEMENT( out, 1, 1,  c );
    SET_ELEMENT( out, 1, 2, -s );
    SET_ELEMENT( out, 2, 1,  s );
    SET_ELEMENT( out, 2, 2,  c );
}

/* http://en.wikipedia.org/wiki/Rotation_representation_%28mathematics%29
   http://en.wikipedia.org/wiki/Rotation_matrix
*/
void
RMtx4RotationY( RMtx4* out, rmReal radian )
{
    rmReal s = rmSin( radian );
    rmReal c = rmCos( radian );

    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 0,  c );
    SET_ELEMENT( out, 0, 2,  s );
    SET_ELEMENT( out, 2, 0, -s );
    SET_ELEMENT( out, 2, 2,  c );
}

/* http://en.wikipedia.org/wiki/Rotation_representation_%28mathematics%29
   http://en.wikipedia.org/wiki/Rotation_matrix
*/
void
RMtx4RotationZ( RMtx4* out, rmReal radian )
{
    rmReal s = rmSin( radian );
    rmReal c = rmCos( radian );

    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 0,  c );
    SET_ELEMENT( out, 0, 1, -s );
    SET_ELEMENT( out, 1, 0,  s );
    SET_ELEMENT( out, 1, 1,  c );
}

/* http://en.wikipedia.org/wiki/Rotation_matrix
 */
void
RMtx4RotationAxis( RMtx4* out, const RVec3* axis, rmReal radian )
{
    rmReal s = rmSin( radian );
    rmReal c = rmCos( radian );
    rmReal C = 1.0f - c;
    rmReal x = RVec3GetX( axis );
    rmReal y = RVec3GetY( axis );
    rmReal z = RVec3GetZ( axis );

    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 0, x*x*C + c );
    SET_ELEMENT( out, 0, 1, x*y*C - z*s );
    SET_ELEMENT( out, 0, 2, z*x*C + y*s );
    SET_ELEMENT( out, 1, 0, x*y*C + z*s );
    SET_ELEMENT( out, 1, 1, y*y*C + c );
    SET_ELEMENT( out, 1, 2, y*z*C - x*s );
    SET_ELEMENT( out, 2, 0, z*x*C - y*s );
    SET_ELEMENT( out, 2, 1, y*z*C + x*s );
    SET_ELEMENT( out, 2, 2, z*z*C + c );
}

/* From Quaternion to Matrix and Back
   http://www.intel.com/cd/ids/developer/asmo-na/eng/293748.htm
*/
void
RMtx4RotationQuaternion( RMtx4* out, const struct RQuat* q )
{
    rmReal x  = RQuatGetX( q );
    rmReal y  = RQuatGetY( q );
    rmReal z  = RQuatGetZ( q );
    rmReal w  = RQuatGetW( q );

    rmReal x2 = 2.0f * x;
    rmReal y2 = 2.0f * y;
    rmReal z2 = 2.0f * z;

    rmReal xx2 = x * x2;
    rmReal yy2 = y * y2;
    rmReal zz2 = z * z2;

    rmReal yz2 = y * z2;
    rmReal wx2 = w * x2;
    rmReal xy2 = x * y2;
    rmReal wz2 = w * z2;
    rmReal xz2 = x * z2;
    rmReal wy2 = w * y2;

    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 0, 1.0f - yy2 - zz2 );
    SET_ELEMENT( out, 1, 0, xy2 + wz2 );
    SET_ELEMENT( out, 2, 0, xz2 - wy2 );
    SET_ELEMENT( out, 0, 1, xy2 - wz2 );
    SET_ELEMENT( out, 1, 1, 1.0f - xx2 - zz2 );
    SET_ELEMENT( out, 2, 1, yz2 + wx2 );
    SET_ELEMENT( out, 0, 2, xz2 + wy2 );
    SET_ELEMENT( out, 1, 2, yz2 - wx2 );
    SET_ELEMENT( out, 2, 2, 1.0f - xx2 - yy2 );
}

void
RMtx4Scaling( RMtx4* out, rmReal sx, rmReal sy, rmReal sz )
{
    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 0, sx );
    SET_ELEMENT( out, 1, 1, sy );
    SET_ELEMENT( out, 2, 2, sz );
}


int
RMtx4Equal( const RMtx4* m1, const RMtx4* m2 )
{
    if ( 0 == memcmp( m1, m2, sizeof(RMtx4) ) )
        return !0;
    else
        return 0;
}


void
RMtx4Add( RMtx4* out, const RMtx4* m1, const RMtx4* m2 )
{
    int row, col;
    RMtx4 tmp;
    for ( row = 0; row < 4; ++row )
        for ( col = 0; col < 4; ++col )
            SET_ELEMENT( &tmp, row, col,
                         GET_ELEMENT( m1, row, col ) + GET_ELEMENT( m2, row, col ) );

    RMtx4Copy( out, &tmp );
}

void
RMtx4Sub( RMtx4* out, const RMtx4* m1, const RMtx4* m2 )
{
    int row, col;
    for ( row = 0; row < 4; ++row )
        for ( col = 0; col < 4; ++col )
            SET_ELEMENT( out, row, col,
                         GET_ELEMENT( m1, row, col ) - GET_ELEMENT( m2, row, col ) );
}

void
RMtx4Mul( RMtx4* out, const RMtx4* m1, const RMtx4* m2 )
{
    int row, col;
    RMtx4 tmp;
    for ( row = 0; row < 4; ++row )
    {
        for ( col = 0; col < 4; ++col )
        {
            int i;
            rmReal sum = 0.0f;
            for ( i = 0; i < 4; ++i )
            {
                sum += GET_ELEMENT( m1, row, i ) * GET_ELEMENT( m2, i, col );
            }
            SET_ELEMENT( &tmp, row, col, sum );
        }
    }

    RMtx4Copy( out, &tmp );
}

void
RMtx4Scale( RMtx4* out, const RMtx4* m, rmReal f )
{
    int row, col;
    for ( row = 0; row < 4; ++row )
        for ( col = 0; col < 4; ++col )
            SET_ELEMENT( out, row, col,
                         GET_ELEMENT( m, row, col ) * f );
}

/* http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/glu/lookat.html
   http://msdn.microsoft.com/en-us/library/bb205343.aspx
*/
void
RMtx4LookAtRH( RMtx4* out, const RVec3* eye, const RVec3* at, const RVec3* up )
{
#define AX(i) RVec3GetElement( &axis_x, i )
#define AY(i) RVec3GetElement( &axis_y, i )
#define AZ(i) RVec3GetElement( &axis_z, i )

    RVec3 axis_x, axis_y, axis_z;

    RMtx4Identity( out );

    RVec3Sub( &axis_z, eye, at );
    RVec3Normalize( &axis_z, &axis_z );

    RVec3Cross( &axis_x, up, &axis_z );
    RVec3Normalize( &axis_x, &axis_x );

    RVec3Cross( &axis_y, &axis_z, &axis_x );

    SET_ELEMENT( out, 0, 0,  AX(0) );
    SET_ELEMENT( out, 0, 1,  AX(1) );
    SET_ELEMENT( out, 0, 2,  AX(2) );
    SET_ELEMENT( out, 0, 3,  -RVec3Dot(&axis_x, eye) );

    SET_ELEMENT( out, 1, 0,  AY(0) );
    SET_ELEMENT( out, 1, 1,  AY(1) );
    SET_ELEMENT( out, 1, 2,  AY(2) );
    SET_ELEMENT( out, 1, 3,  -RVec3Dot(&axis_y, eye) );

    SET_ELEMENT( out, 2, 0,  AZ(0) );
    SET_ELEMENT( out, 2, 1,  AZ(1) );
    SET_ELEMENT( out, 2, 2,  AZ(2) );
    SET_ELEMENT( out, 2, 3,  -RVec3Dot(&axis_z, eye) );

#undef AX
#undef AY
#undef AZ
}

void
RMtx4PerspectiveRH( RMtx4* out, rmReal width, rmReal height, rmReal znear, rmReal zfar )
{
    RMtx4PerspectiveOffCenterRH( out, -width/2.0f, width/2.0f, -height/2.0f, height/2.0f, znear, zfar );
}

/* http://pyopengl.sourceforge.net/documentation/manual/gluPerspective.3G.html
 */
void
RMtx4PerspectiveFovRH( RMtx4* out, rmReal fovy_radian, rmReal aspect, rmReal znear, rmReal zfar )
{
    rmReal f = rmTan( fovy_radian / 2.0f );
    f = 1.0f / f;

    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 0, f / aspect );
    SET_ELEMENT( out, 1, 1, f );
    SET_ELEMENT( out, 2, 2, (zfar+znear)/(znear-zfar) );
    SET_ELEMENT( out, 2, 3, 2*zfar*znear/(znear-zfar) );
    SET_ELEMENT( out, 3, 2, -1.0f );
    SET_ELEMENT( out, 3, 3, 0.0f );
}

/* http://pyopengl.sourceforge.net/documentation/manual/glFrustum.3G.html
 */
void
RMtx4PerspectiveOffCenterRH( RMtx4* out, rmReal left, rmReal right, rmReal bottom, rmReal top, rmReal znear, rmReal zfar )
{
    rmReal A = (right+left) / (right-left);
    rmReal B = (top+bottom) / (top-bottom);
    rmReal C = -(zfar+znear) / (zfar-znear);
    rmReal D = -(2*znear*zfar) / (zfar-znear);

    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 0, 2*znear/(right-left) );
    SET_ELEMENT( out, 0, 2, A );
    SET_ELEMENT( out, 1, 1, 2*znear/(top-bottom) );
    SET_ELEMENT( out, 1, 2, B );
    SET_ELEMENT( out, 2, 2, C );
    SET_ELEMENT( out, 2, 3, D );
    SET_ELEMENT( out, 3, 2, -1.0f );
    SET_ELEMENT( out, 3, 3,  0.0f );
}

void
RMtx4OrthoRH( RMtx4* out, rmReal width, rmReal height, rmReal znear, rmReal zfar )
{
    RMtx4OrthoOffCenterRH( out, -width/2.0f, width/2.0f, -height/2.0f, height/2.0f, znear, zfar );
}

/* http://pyopengl.sourceforge.net/documentation/manual/glOrtho.3G.html
 */
void
RMtx4OrthoOffCenterRH( RMtx4* out, rmReal left, rmReal right, rmReal bottom, rmReal top, rmReal znear, rmReal zfar )
{
    rmReal tx = (right+left) / (right-left);
    rmReal ty = (top+bottom) / (top-bottom);
    rmReal tz = (zfar+znear) / (zfar-znear);

    RMtx4Identity( out );
    SET_ELEMENT( out, 0, 0, 2.0f/(right-left) );
    SET_ELEMENT( out, 0, 3, tx );
    SET_ELEMENT( out, 1, 1, 2.0f/(top-bottom) );
    SET_ELEMENT( out, 1, 3, ty );
    SET_ELEMENT( out, 2, 2, -2.0f/(zfar-znear) );
    SET_ELEMENT( out, 2, 3, tz );
}


/*
RMath : Ruby math module for 3D Applications
Copyright (c) 2008- vaiorabbit  <http://twitter.com/vaiorabbit>

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
 */
