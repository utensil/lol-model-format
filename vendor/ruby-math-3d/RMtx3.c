#include <math.h>
#include <string.h>

#include "RVec3.h"
#include "RQuat.h"
#include "RMtx3.h"

/* NOTE : column-major */
#define SET_ELEMENT(out, row, col, val) (out)->e[(col)*3+(row)] = (val)
#define GET_ELEMENT(in, row, col) ((in)->e[(col)*3+(row)])

void
RMtx3SetElement( RMtx3* out, int row, int col, rmReal e )
{
    SET_ELEMENT( out, row, col, e );
}

rmReal
RMtx3GetElement( const RMtx3* in, int row, int col )
{
    return GET_ELEMENT( in, row, col );
}

void
RMtx3GetRow( RVec3* out, const RMtx3* in, int row )
{
    RVec3SetX( out, GET_ELEMENT( in, row, 0 ) );
    RVec3SetY( out, GET_ELEMENT( in, row, 1 ) );
    RVec3SetZ( out, GET_ELEMENT( in, row, 2 ) );
}

void
RMtx3GetColumn( RVec3* out, const RMtx3* in, int col )
{
    RVec3SetX( out, GET_ELEMENT( in, 0, col ) );
    RVec3SetY( out, GET_ELEMENT( in, 1, col ) );
    RVec3SetZ( out, GET_ELEMENT( in, 2, col ) );
}

void
RMtx3SetRow( RMtx3* out, const RVec3* in, int row )
{
    SET_ELEMENT( out, row, 0, RVec3GetElement( in, 0 ) );
    SET_ELEMENT( out, row, 1, RVec3GetElement( in, 1 ) );
    SET_ELEMENT( out, row, 2, RVec3GetElement( in, 2 ) );
}

void
RMtx3SetColumn( RMtx3* out, const RVec3* in, int col )
{
    SET_ELEMENT( out, 0, col, RVec3GetElement( in, 0 ) );
    SET_ELEMENT( out, 1, col, RVec3GetElement( in, 1 ) );
    SET_ELEMENT( out, 2, col, RVec3GetElement( in, 2 ) );
}

void
RMtx3Copy( RMtx3* out, const RMtx3* in )
{
    memmove( out, in, sizeof(RMtx3) );
}

void
RMtx3SetElements( RMtx3* out,
                  rmReal e00, rmReal e01, rmReal e02,
                  rmReal e10, rmReal e11, rmReal e12,
                  rmReal e20, rmReal e21, rmReal e22
    )
{
    SET_ELEMENT( out, 0, 0, e00 );
    SET_ELEMENT( out, 0, 1, e01 );
    SET_ELEMENT( out, 0, 2, e02 );

    SET_ELEMENT( out, 1, 0, e10 );
    SET_ELEMENT( out, 1, 1, e11 );
    SET_ELEMENT( out, 1, 2, e12 );

    SET_ELEMENT( out, 2, 0, e20 );
    SET_ELEMENT( out, 2, 1, e21 );
    SET_ELEMENT( out, 2, 2, e22 );
}

void
RMtx3Zero( RMtx3* out )
{
    int row, col;
    for ( row = 0; row < 3; ++row )
        for ( col = 0; col < 3; ++col )
            SET_ELEMENT( out, row, col, 0.0f );
}

void
RMtx3Identity( RMtx3* out )
{
    int row, col;
    for ( row = 0; row < 3; ++row )
        for ( col = 0; col < 3; ++col )
            SET_ELEMENT( out, row, col, (row==col) ? 1.0f : 0.0f );
}

rmReal
RMtx3Determinant( const RMtx3* in )
{
#define I( r, c ) GET_ELEMENT( in, (r), (c) )
#define D( e00, e01, e10, e11 ) ((e00)*(e11)-(e01)*(e10))

    return
        I(0,0) * D( I(1,1), I(1,2), I(2,1), I(2,2) ) -
        I(0,1) * D( I(1,0), I(1,2), I(2,0), I(2,2) ) +
        I(0,2) * D( I(1,0), I(1,1), I(2,0), I(2,1) ) ;

#undef I
#undef D
}

void
RMtx3Transpose( RMtx3* out, const RMtx3* in )
{
    int row, col;
    RMtx3 tmp;
    for ( row = 0; row < 3; ++row )
        for ( col = 0; col < 3; ++col )
            SET_ELEMENT( &tmp, row, col, GET_ELEMENT( in, col, row ) );

    RMtx3Copy( out, &tmp );
}

rmReal
RMtx3Inverse( RMtx3* out, const RMtx3* in )
{
#define I( r, c ) GET_ELEMENT( in, (r), (c) )
#define R( r, c ) GET_ELEMENT( &result, (r), (c) )
#define D( e00, e01, e10, e11 ) ((e00)*(e11)-(e01)*(e10))

    RMtx3 result;
    rmReal det;

    SET_ELEMENT( &result, 0, 0,  D( I(1,1),I(1,2), I(2,1),I(2,2) ) );
    SET_ELEMENT( &result, 0, 1, -D( I(0,1),I(0,2), I(2,1),I(2,2) ) );
    SET_ELEMENT( &result, 0, 2,  D( I(0,1),I(0,2), I(1,1),I(1,2) ) );

    SET_ELEMENT( &result, 1, 0, -D( I(1,0),I(1,2), I(2,0),I(2,2) ) );
    SET_ELEMENT( &result, 1, 1,  D( I(0,0),I(0,2), I(2,0),I(2,2) ) );
    SET_ELEMENT( &result, 1, 2, -D( I(0,0),I(0,2), I(1,0),I(1,2) ) );

    SET_ELEMENT( &result, 2, 0,  D( I(1,0),I(1,1), I(2,0),I(2,1) ) );
    SET_ELEMENT( &result, 2, 1, -D( I(0,0),I(0,1), I(2,0),I(2,1) ) );
    SET_ELEMENT( &result, 2, 2,  D( I(0,0),I(0,1), I(1,0),I(1,1) ) );

    det = I(0,0) * R(0,0) + I(0,1) * R(1,0) + I(0,2) * R(2,0);

    if ( rmFabs(det) < RMATH_TOLERANCE )
        return det;

    RMtx3Scale( out, &result, 1.0f / det );

    return det;

#undef I
#undef R
#undef D
}


/* http://en.wikipedia.org/wiki/Rotation_representation_%28mathematics%29
   http://en.wikipedia.org/wiki/Rotation_matrix
*/
void
RMtx3RotationX( RMtx3* out, rmReal radian )
{
    rmReal s = rmSin( radian );
    rmReal c = rmCos( radian );

    RMtx3Identity( out );
    SET_ELEMENT( out, 1, 1,  c );
    SET_ELEMENT( out, 1, 2, -s );
    SET_ELEMENT( out, 2, 1,  s );
    SET_ELEMENT( out, 2, 2,  c );
}

/* http://en.wikipedia.org/wiki/Rotation_representation_%28mathematics%29
   http://en.wikipedia.org/wiki/Rotation_matrix
*/
void
RMtx3RotationY( RMtx3* out, rmReal radian )
{
    rmReal s = rmSin( radian );
    rmReal c = rmCos( radian );

    RMtx3Identity( out );
    SET_ELEMENT( out, 0, 0,  c );
    SET_ELEMENT( out, 0, 2,  s );
    SET_ELEMENT( out, 2, 0, -s );
    SET_ELEMENT( out, 2, 2,  c );
}

/* http://en.wikipedia.org/wiki/Rotation_representation_%28mathematics%29
   http://en.wikipedia.org/wiki/Rotation_matrix
*/
void
RMtx3RotationZ( RMtx3* out, rmReal radian )
{
    rmReal s = rmSin( radian );
    rmReal c = rmCos( radian );

    RMtx3Identity( out );
    SET_ELEMENT( out, 0, 0,  c );
    SET_ELEMENT( out, 0, 1, -s );
    SET_ELEMENT( out, 1, 0,  s );
    SET_ELEMENT( out, 1, 1,  c );
}

/* http://en.wikipedia.org/wiki/Rotation_matrix
 */
void
RMtx3RotationAxis( RMtx3* out, const RVec3* axis, rmReal radian )
{
    rmReal s = rmSin( radian );
    rmReal c = rmCos( radian );
    rmReal C = 1.0f - c;
    rmReal x = RVec3GetX( axis );
    rmReal y = RVec3GetY( axis );
    rmReal z = RVec3GetZ( axis );

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
RMtx3RotationQuaternion( RMtx3* out, const struct RQuat* q )
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

    RMtx3Identity( out );
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
RMtx3Scaling( RMtx3* out, rmReal sx, rmReal sy, rmReal sz )
{
    RMtx3Identity( out );
    SET_ELEMENT( out, 0, 0, sx );
    SET_ELEMENT( out, 1, 1, sy );
    SET_ELEMENT( out, 2, 2, sz );
}


int
RMtx3Equal( const RMtx3* m1, const RMtx3* m2 )
{
    if ( 0 == memcmp( m1, m2, sizeof(RMtx3) ) )
        return !0;
    else
        return 0;
}


void
RMtx3Add( RMtx3* out, const RMtx3* m1, const RMtx3* m2 )
{
    int row, col;
    RMtx3 tmp;
    for ( row = 0; row < 3; ++row )
        for ( col = 0; col < 3; ++col )
            SET_ELEMENT( &tmp, row, col,
                         GET_ELEMENT( m1, row, col ) + GET_ELEMENT( m2, row, col ) );

    RMtx3Copy( out, &tmp );
}

void
RMtx3Sub( RMtx3* out, const RMtx3* m1, const RMtx3* m2 )
{
    int row, col;
    for ( row = 0; row < 3; ++row )
        for ( col = 0; col < 3; ++col )
            SET_ELEMENT( out, row, col,
                         GET_ELEMENT( m1, row, col ) - GET_ELEMENT( m2, row, col ) );
}

void
RMtx3Mul( RMtx3* out, const RMtx3* m1, const RMtx3* m2 )
{
    int row, col;
    RMtx3 tmp;
    for ( row = 0; row < 3; ++row )
    {
        for ( col = 0; col < 3; ++col )
        {
            int i;
            rmReal sum = 0.0f;
            for ( i = 0; i < 3; ++i )
            {
                sum += GET_ELEMENT( m1, row, i ) * GET_ELEMENT( m2, i, col );
            }
            SET_ELEMENT( &tmp, row, col, sum );
        }
    }

    RMtx3Copy( out, &tmp );
}

void
RMtx3Scale( RMtx3* out, const RMtx3* m, rmReal f )
{
    int row, col;
    for ( row = 0; row < 3; ++row )
        for ( col = 0; col < 3; ++col )
            SET_ELEMENT( out, row, col,
                         GET_ELEMENT( m, row, col ) * f );
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
