#include <math.h>
#include <string.h>

#include "RVec3.h"
#include "RVec4.h"
#include "RQuat.h"
#include "RMtx3.h"
#include "RMtx4.h"

#define SET_ELEMENT( out, at, f )

void
RVec3SetElement( RVec3* out, int at, rmReal f )
{
    out->e[at] = f;
}

void
RVec3SetX( RVec3* out, rmReal x )
{
    out->x = x;
}

void
RVec3SetY( RVec3* out, rmReal y )
{
    out->y = y;
}

void
RVec3SetZ( RVec3* out, rmReal z )
{
    out->z = z;
}

void
RVec3SetElements( RVec3* out, rmReal x, rmReal y, rmReal z )
{
    RVec3SetX( out, x );
    RVec3SetY( out, y );
    RVec3SetZ( out, z );
}

rmReal
RVec3GetElement( const RVec3* in, int at )
{
    return in->e[at];
}

rmReal
RVec3GetX( const RVec3* in )
{
    return in->x;
}

rmReal
RVec3GetY( const RVec3* in )
{
    return in->y;
}

rmReal
RVec3GetZ( const RVec3* in )
{
    return in->z;
}

int
RVec3Equal( const RVec3* v1, const RVec3* v2 )
{
    if ( 0 == memcmp( v1, v2, sizeof(RVec3) ) )
        return !0;
    else
        return 0;
}

void
RVec3Add( RVec3* out, const RVec3* v1, const RVec3* v2 )
{
    out->x = v1->x + v2->x;
    out->y = v1->y + v2->y;
    out->z = v1->z + v2->z;
}

void
RVec3Sub( RVec3* out, const RVec3* v1, const RVec3* v2 )
{
    out->x = v1->x - v2->x;
    out->y = v1->y - v2->y;
    out->z = v1->z - v2->z;
}

void
RVec3Scale( RVec3* out, const RVec3* in, rmReal f )
{
    out->x = in->x * f;
    out->y = in->y * f;
    out->z = in->z * f;
}

void
RVec3Cross( RVec3* out, const RVec3* v1, const RVec3* v2 )
{
    RVec3 tmp;
    rmReal v1x, v1y, v1z, v2x, v2y, v2z;

    v1x = v1->x;
    v1y = v1->y;
    v1z = v1->z;
    v2x = v2->x;
    v2y = v2->y;
    v2z = v2->z;

    tmp.x = v1y*v2z - v1z*v2y;
    tmp.y = v1z*v2x - v1x*v2z;
    tmp.z = v1x*v2y - v1y*v2x;

    RVec3Copy( out, &tmp );
}

rmReal
RVec3LengthSq( const RVec3* in )
{
    return in->x*in->x + in->y*in->y + in->z*in->z;
}

rmReal
RVec3Length( const RVec3* in )
{
    return rmSqrt( in->x*in->x + in->y*in->y + in->z*in->z );
}

rmReal
RVec3Dot( const RVec3* v1, const RVec3* v2 )
{
    return v1->x*v2->x + v1->y*v2->y + v1->z*v2->z;
}

void
RVec3Copy( RVec3* out, const RVec3* in )
{
    out->x = in->x;
    out->y = in->y;
    out->z = in->z;
}

void
RVec3Normalize( RVec3* out, const RVec3* in )
{
    rmReal length = RVec3Length( in );
    RVec3Scale( out, in, 1.0f/length );
}

void
RVec3Transform( RVec4* out, const RMtx4* m, const RVec3* in )
{
    RVec4 result, in_vec4;
    int row;

    RVec4SetXYZ( &in_vec4, in );
    RVec4SetW( &in_vec4, 1.0f );
    for ( row = 0; row < 4; ++row )
    {
        RVec4 row_vector;
        RMtx4GetRow( &row_vector, m, row );
        RVec4SetElement( &result, row, RVec4Dot( &row_vector, &in_vec4 ) );
    }
    RVec4Copy( out, &result );
}

void
RVec3TransformCoord( RVec3* out, const RMtx4* m, const RVec3* in )
{
    RVec4 tmp;
    rmReal w;

    RVec3Transform( &tmp, m, in );
    w = RVec4GetW( &tmp );
    w = 1.0f / w;

    out->x = w * RVec4GetX( &tmp );
    out->y = w * RVec4GetY( &tmp );
    out->z = w * RVec4GetZ( &tmp );
}

void
RVec3TransformNormal( RVec3* out, const RMtx4* m, const RVec3* in )
{
    RVec4 result, in_vec4;
    int row;

    RVec4SetXYZ( &in_vec4, in );
    RVec4SetW( &in_vec4, 0.0f );
    for ( row = 0; row < 4; ++row )
    {
        RVec4 row_vector;
        RMtx4GetRow( &row_vector, m, row );
        RVec4SetElement( &result, row, RVec4Dot( &row_vector, &in_vec4 ) );
    }

    out->x = RVec4GetX( &result );
    out->y = RVec4GetY( &result );
    out->z = RVec4GetZ( &result );
}

void
RVec3TransformRS( RVec3* out, const RMtx3* m, const RVec3* in )
{
    RVec3 result;
    int row;

    for ( row = 0; row < 3; ++row )
    {
        RVec3 row_vector;
        RMtx3GetRow( &row_vector, m, row );
        RVec3SetElement( &result, row, RVec3Dot( &row_vector, in ) );
    }

    out->x = RVec3GetX( &result );
    out->y = RVec3GetY( &result );
    out->z = RVec3GetZ( &result );
}

void
RVec3TransformRSTransposed( RVec3* out, const struct RMtx3* m, const RVec3* in )
{
    RVec3 result;
    int column;

    for ( column = 0; column < 3; ++column )
    {
        RVec3 column_vector;
        RMtx3GetColumn( &column_vector, m, column );
        RVec3SetElement( &result, column, RVec3Dot( &column_vector, in ) );
    }

    out->x = RVec3GetX( &result );
    out->y = RVec3GetY( &result );
    out->z = RVec3GetZ( &result );
}

void
RVec3TransformByQuaternion( RVec3* out, const struct RQuat* q, const RVec3* in )
{
    rmReal qcx = -q->x;
    rmReal qcy = -q->y;
    rmReal qcz = -q->z;
    rmReal qcw =  q->w;
    rmReal v_x = in->x;
    rmReal v_y = in->y;
    rmReal v_z = in->z;

    rmReal t_x = q->w*v_x            + q->y*v_z - q->z*v_y;
    rmReal t_y = q->w*v_y - q->x*v_z            + q->z*v_x;
    rmReal t_z = q->w*v_z + q->x*v_y - q->y*v_x           ;
    rmReal t_w =          - q->x*v_x - q->y*v_y - q->z*v_z;

    out->x = t_w*qcx + t_x*qcw + t_y*qcz - t_z*qcy;
    out->y = t_w*qcy - t_x*qcz + t_y*qcw + t_z*qcx;
    out->z = t_w*qcz + t_x*qcy - t_y*qcx + t_z*qcw;
}

/*
RMath : Ruby math module for 3D Applications
Copyright (c) 2008- vaiorabbit  <http://twitter.com/vaiorabbit>.

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
