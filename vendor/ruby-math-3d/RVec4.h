/* -*- C -*- */
#ifndef RMATHVEC4_H_INCLUDED
#define RMATHVEC4_H_INCLUDED

#include "RType.h"

struct RVec3;
struct RMtx4;

typedef struct RVec4
{
    union
    {
        struct
        {
            rmReal x, y, z, w;
        };
        rmReal e[4];
    };
} RVec4;

#ifdef __cplusplus
extern "C" {
#endif

void    RVec4SetElements( RVec4* out, rmReal x, rmReal y, rmReal z, rmReal w );
void    RVec4SetElement( RVec4* out, int at, rmReal f );
void    RVec4SetX( RVec4* out, rmReal x );
void    RVec4SetY( RVec4* out, rmReal y );
void    RVec4SetZ( RVec4* out, rmReal z );
void    RVec4SetW( RVec4* out, rmReal w );
void    RVec4SetXYZ( RVec4* out, const struct RVec3* v );

rmReal  RVec4GetElement( const RVec4* in, int at );
rmReal  RVec4GetX( const RVec4* in );
rmReal  RVec4GetY( const RVec4* in );
rmReal  RVec4GetZ( const RVec4* in );
rmReal  RVec4GetW( const RVec4* in );
void    RVec4GetXYZ( struct RVec3* out, const RVec4* in );

int     RVec4Equal( const RVec4* v1, const RVec4* v2 );

void    RVec4Add( RVec4* out, const RVec4* v1, const RVec4* v2 );
void    RVec4Sub( RVec4* out, const RVec4* v1, const RVec4* v2 );
void    RVec4Scale( RVec4* out, const RVec4* in, rmReal f );

rmReal  RVec4Length( const RVec4* in );
rmReal  RVec4LengthSq( const RVec4* in );

rmReal  RVec4Dot( const RVec4* v1, const RVec4* v2 );

void    RVec4Copy( RVec4* out, const RVec4* in );
void    RVec4Normalize( RVec4* out, const RVec4* in );

void    RVec4Transform( RVec4* out, const struct RMtx4* m, const RVec4* in );
void    RVec4TransformTransposed( RVec4* out, const struct RMtx4* m, const RVec4* in );

#ifdef __cplusplus
}
#endif

#endif

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
