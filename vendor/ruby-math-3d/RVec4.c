#include <math.h>
#include <string.h>

#include "RVec3.h"
#include "RVec4.h"
#include "RMtx4.h"

void
RVec4SetElement( RVec4* out, int at, rmReal f )
{
    out->e[at] = f;
}

void
RVec4SetX( RVec4* out, rmReal x )
{
    out->x = x;
}

void
RVec4SetY( RVec4* out, rmReal y )
{
    out->y = y;
}

void
RVec4SetZ( RVec4* out, rmReal z )
{
    out->z = z;
}

void
RVec4SetW( RVec4* out, rmReal w )
{
    out->w = w;
}

void
RVec4SetXYZ( RVec4* out, const RVec3* v )
{
    out->x = RVec3GetX( v );
    out->y = RVec3GetY( v );
    out->z = RVec3GetZ( v );
}

void
RVec4SetElements( RVec4* out, rmReal x, rmReal y, rmReal z, rmReal w )
{
    out->x = x;
    out->y = y;
    out->z = z;
    out->w = w;
}

rmReal
RVec4GetElement( const RVec4* in, int at )
{
    return in->e[at];
}

rmReal
RVec4GetX( const RVec4* in )
{
    return in->x;
}

rmReal
RVec4GetY( const RVec4* in )
{
    return in->y;
}

rmReal
RVec4GetZ( const RVec4* in )
{
    return in->z;
}

rmReal
RVec4GetW( const RVec4* in )
{
    return in->w;
}

void
RVec4GetXYZ( struct RVec3* out, const RVec4* in )
{
    RVec3SetX( out, in->x );
    RVec3SetY( out, in->y );
    RVec3SetZ( out, in->z );
}

int
RVec4Equal( const RVec4* v1, const RVec4* v2 )
{
    if ( 0 == memcmp( v1, v2, sizeof(RVec4) ) )
        return !0;
    else
        return 0;
}

void
RVec4Add( RVec4* out, const RVec4* v1, const RVec4* v2 )
{
    out->x = v1->x + v2->x;
    out->y = v1->y + v2->y;
    out->z = v1->z + v2->z;
    out->w = v1->w + v2->w;
}

void
RVec4Sub( RVec4* out, const RVec4* v1, const RVec4* v2 )
{
    out->x = v1->x - v2->x;
    out->y = v1->y - v2->y;
    out->z = v1->z - v2->z;
    out->w = v1->w - v2->w;
}

void
RVec4Scale( RVec4* out, const RVec4* in, rmReal f )
{
    out->x = in->x * f;
    out->y = in->y * f;
    out->z = in->z * f;
    out->w = in->w * f;
}

rmReal
RVec4LengthSq( const RVec4* in )
{
    return in->x*in->x + in->y*in->y + in->z*in->z + in->w*in->w;
}

rmReal
RVec4Length( const RVec4* in )
{
    return rmSqrt( in->x*in->x + in->y*in->y + in->z*in->z + in->w*in->w );
}

rmReal
RVec4Dot( const RVec4* v1, const RVec4* v2 )
{
    return v1->x*v2->x + v1->y*v2->y + v1->z*v2->z + v1->w*v2->w;
}

void
RVec4Copy( RVec4* out, const RVec4* in )
{
    out->x = in->x;
    out->y = in->y;
    out->z = in->z;
    out->w = in->w;
}

void
RVec4Normalize( RVec4* out, const RVec4* in )
{
    rmReal length = RVec4Length( in );
    RVec4Scale( out, in, 1.0f/length );
}

void
RVec4Transform( RVec4* out, const RMtx4* m, const RVec4* in )
{
    /* out <- m * in */
    RVec4 result;
    int row;
    for ( row = 0; row < 4; ++row )
    {
        RVec4 row_vector;
        RMtx4GetRow( &row_vector, m, row );
        RVec4SetElement( &result, row, RVec4Dot( &row_vector, in ) );
    }
    RVec4Copy( out, &result );
}

void
RVec4TransformTransposed( RVec4* out, const struct RMtx4* m, const RVec4* in )
{
    /* out <- m^T * in */
    RVec4 result;
    int column;
    for ( column = 0; column < 4; ++column )
    {
        RVec4 column_vector;
        RMtx4GetColumn( &column_vector, m, column );
        RVec4SetElement( &result, column, RVec4Dot( &column_vector, in ) );
    }
    RVec4Copy( out, &result );
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
