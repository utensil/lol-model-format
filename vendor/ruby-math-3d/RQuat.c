#include <math.h>
#include <string.h>

#include "RVec3.h"
#include "RMtx4.h"
#include "RQuat.h"

void
RQuatSetElements( RQuat* out, rmReal x, rmReal y, rmReal z, rmReal w )
{
    RQuatSetX( out, x );
    RQuatSetY( out, y );
    RQuatSetZ( out, z );
    RQuatSetW( out, w );
}

void
RQuatSetElement( RQuat* out, int at, rmReal f )
{
    out->e[at] = f;
}

void
RQuatSetX( RQuat* out, rmReal x )
{
    out->x = x;
}

void
RQuatSetY( RQuat* out, rmReal y )
{
    out->y = y;
}

void
RQuatSetZ( RQuat* out, rmReal z )
{
    out->z = z;
}

void
RQuatSetW( RQuat* out, rmReal w )
{
    out->w = w;
}

void
RQuatSetXYZ( RQuat* out, const struct RVec3* v )
{
    out->x = RVec3GetX( v );
    out->y = RVec3GetY( v );
    out->z = RVec3GetZ( v );
}


rmReal
RQuatGetElement( const RQuat* in, int at )
{
    return in->e[at];
}

rmReal
RQuatGetX( const RQuat* in )
{
    return in->x;
}

rmReal
RQuatGetY( const RQuat* in )
{
    return in->y;
}

rmReal
RQuatGetZ( const RQuat* in )
{
    return in->z;
}

rmReal
RQuatGetW( const RQuat* in )
{
    return in->w;
}

void
RQuatGetXYZ( struct RVec3* out, const RQuat* in )
{
    RVec3SetX( out, in->x );
    RVec3SetY( out, in->y );
    RVec3SetZ( out, in->z );
}


int
RQuatEqual( const RQuat* q1, const RQuat* q2 )
{
    if ( 0 == memcmp( q1, q2, sizeof(RQuat) ) )
        return !0;
    else
        return 0;
}

rmReal
RQuatDot( const RQuat* q1, const RQuat* q2 )
{
    return q1->x*q2->x + q1->y*q2->y + q1->z*q2->z + q1->w*q2->w;
}


void
RQuatIdentity( RQuat* out )
{
    RQuatSetElements( out, 0.0f, 0.0f, 0.0f, 1.0f );
}

void
RQuatCopy( RQuat* out, const RQuat* in )
{
    out->x = in->x;
    out->y = in->y;
    out->z = in->z;
    out->w = in->w;
}

void
RQuatNormalize( RQuat* out, const RQuat* in )
{
    rmReal length = RQuatLength( in );
    RQuatScale( out, in, 1.0f/length );
}

void
RQuatConjugate( RQuat* out, const RQuat* in )
{
    out->x = -in->x;
    out->y = -in->y;
    out->z = -in->z;
    out->w =  in->w;
}

void
RQuatInverse( RQuat* out, const RQuat* in )
{
    rmReal length_sq = RQuatLengthSq( in );
    RQuat qc;

    RQuatConjugate( &qc, in );
    RQuatScale( &qc, &qc, 1.0f/length_sq );
    RQuatCopy( out, &qc );
}


void
RQuatAdd( RQuat* out, const RQuat* q1, const RQuat* q2 )
{
    out->x = q1->x + q2->x;
    out->y = q1->y + q2->y;
    out->z = q1->z + q2->z;
    out->w = q1->w + q2->w;
}

void
RQuatSub( RQuat* out, const RQuat* q1, const RQuat* q2 )
{
    out->x = q1->x - q2->x;
    out->y = q1->y - q2->y;
    out->z = q1->z - q2->z;
    out->w = q1->w - q2->w;
}

/* http://en.wikipedia.org/wiki/Quaternion
 */
void
RQuatMul( RQuat* out, const RQuat* q1, const RQuat* q2 )
{
    rmReal x, y, z, w;
    rmReal q1x = q1->x;
    rmReal q1y = q1->y;
    rmReal q1z = q1->z;
    rmReal q1w = q1->w;
    rmReal q2x = q2->x;
    rmReal q2y = q2->y;
    rmReal q2z = q2->z;
    rmReal q2w = q2->w;

    x = q1w*q2x + q1x*q2w + q1y*q2z - q1z*q2y;
    y = q1w*q2y - q1x*q2z + q1y*q2w + q1z*q2x;
    z = q1w*q2z + q1x*q2y - q1y*q2x + q1z*q2w;
    w = q1w*q2w - q1x*q2x - q1y*q2y - q1z*q2z;

    RQuatSetElements( out, x, y, z, w );
}

void
RQuatScale( RQuat* out, const RQuat* in, rmReal f )
{
    out->x = in->x * f;
    out->y = in->y * f;
    out->z = in->z * f;
    out->w = in->w * f;
}


rmReal
RQuatLength( const RQuat* in )
{
    return rmSqrt( in->x*in->x + in->y*in->y + in->z*in->z + in->w*in->w );
}

rmReal
RQuatLengthSq( const RQuat* in )
{
    return in->x*in->x + in->y*in->y + in->z*in->z + in->w*in->w;
}


/* Quaternion Algebra and Calculus
   http://www.geometrictools.com/Documentation/Quaternions.pdf
*/
void
RQuatSlerp( RQuat* out, const RQuat* q1, const RQuat* q2, rmReal t )
{
    rmReal s1, s2;
    rmReal it = 1.0f - t;
    rmReal cosine = RQuatDot( q1, q2 );
    RQuat qn1, qn2, qResult;
    RQuatCopy( &qn1, q1 );
    RQuatCopy( &qn2, q2 );

    if ( cosine < 0.0f )
    {
        cosine *= -1.0f;
        RQuatScale( &qn1, &qn1, -1.0f );
    }

    if ( (1.0f - cosine) > RMATH_TOLERANCE )
    {
        rmReal theta = rmAcos( cosine );
        rmReal sin_theta = rmSin( theta );

        s1 = rmSin( it * theta ) / sin_theta;
        s2 = rmSin(  t * theta ) / sin_theta;
    }
    else
    {
        s1 = it;
        s2 = t;
    }

    RQuatScale( &qn1, &qn1, s1 );
    RQuatScale( &qn2, &qn2, s2 );
    RQuatAdd( &qResult, &qn1, &qn2 );

    RQuatCopy( out, &qResult );
}


/* From Quaternion to Matrix and Back
   http://www.intel.com/cd/ids/developer/asmo-na/eng/293748.htm
*/
void
RQuatRotationMatrix( RQuat* out, const struct RMtx4* mtx )
{
#define I( r, c ) RMtx4GetElement( mtx, (r), (c) )

/* assumes:
   - mtx represents rotation (contains no scaling factor)
   - I(3,3) == 1.0f
*/
    rmReal diag00 = I( 0, 0 );
    rmReal diag11 = I( 1, 1 );
    rmReal diag22 = I( 2, 2 );

    if ( diag00 + diag11 + diag22 > 0.0f )
    {
        rmReal t = diag00 + diag11 + diag22 + 1.0f;
        rmReal s = 1.0f / ( rmSqrt( t ) * 2.0f );
        RQuatSetW( out, s * t );
        RQuatSetZ( out, (I(1,0) - I(0,1)) * s );
        RQuatSetY( out, (I(0,2) - I(2,0)) * s );
        RQuatSetX( out, (I(2,1) - I(1,2)) * s );
    }
    else if ( diag00 > diag11 && diag00 > diag22 )
    {
        rmReal t = diag00 - diag11 - diag22 + 1.0f;
        rmReal s = 1.0f / ( rmSqrt( t ) * 2.0f );
        RQuatSetX( out, s * t );
        RQuatSetY( out, (I(1,0) + I(0,1)) * s );
        RQuatSetZ( out, (I(0,2) + I(2,0)) * s );
        RQuatSetW( out, (I(2,1) - I(1,2)) * s );
    }
    else if ( diag11 > diag22 )
    {
        rmReal t = -diag00 + diag11 - diag22 + 1.0f;
        rmReal s = 1.0f / ( rmSqrt( t ) * 2.0f );
        RQuatSetY( out, s * t );
        RQuatSetX( out, (I(1,0) + I(0,1)) * s );
        RQuatSetW( out, (I(0,2) - I(2,0)) * s );
        RQuatSetZ( out, (I(2,1) + I(1,2)) * s );
    }
    else
    {
        rmReal t = -diag00 - diag11 + diag22 + 1.0f;
        rmReal s = 1.0f / ( rmSqrt( t ) * 2.0f );
        RQuatSetZ( out, s * t );
        RQuatSetW( out, (I(1,0) - I(0,1)) * s );
        RQuatSetX( out, (I(0,2) + I(2,0)) * s );
        RQuatSetY( out, (I(2,1) + I(1,2)) * s );
    }

#undef I
}

void
RQuatRotationAxis( RQuat* out, const struct RVec3* axis, rmReal radian )
{
    rmReal s = rmSin( radian / 2.0f );
    rmReal x, y, z, w;

    x = s * RVec3GetX( axis );
    y = s * RVec3GetY( axis );
    z = s * RVec3GetZ( axis );
    w = rmCos( radian / 2.0f );

    RQuatSetElements( out, x, y, z, w );
}

void
RQuatToAxisAngle( const RQuat* in, struct RVec3* axis, rmReal* radian )
{
    if ( axis )
    {
        RVec3 a;
        RVec3SetElements( &a, in->x, in->y, in->z );
        RVec3Normalize( axis, &a );
    }

    if ( radian )
    {
        *radian = 2.0f * rmAcos( in->w );
    }
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
