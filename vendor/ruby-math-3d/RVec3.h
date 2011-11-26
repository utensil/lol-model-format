/* -*- C -*- */
#ifndef RMATHVEC3_H_INCLUDED
#define RMATHVEC3_H_INCLUDED

#include "RType.h"

struct RVec4;
struct RMtx3;
struct RMtx4;
struct RQuat;

typedef struct RVec3
{
    union
    {
        struct
        {
            rmReal x, y, z;
        };
        rmReal e[3];
    };
} RVec3;

#ifdef __cplusplus
extern "C" {
#endif

void    RVec3SetElements( RVec3* out, rmReal x, rmReal y, rmReal z );
void    RVec3SetElement( RVec3* out, int at, rmReal f );
void    RVec3SetX( RVec3* out, rmReal x );
void    RVec3SetY( RVec3* out, rmReal y );
void    RVec3SetZ( RVec3* out, rmReal z );

rmReal  RVec3GetElement( const RVec3* in, int at );
rmReal  RVec3GetX( const RVec3* in );
rmReal  RVec3GetY( const RVec3* in );
rmReal  RVec3GetZ( const RVec3* in );

int     RVec3Equal( const RVec3* v1, const RVec3* v2 );

void    RVec3Add( RVec3* out, const RVec3* v1, const RVec3* v2 );
void    RVec3Sub( RVec3* out, const RVec3* v1, const RVec3* v2 );
void    RVec3Scale( RVec3* out, const RVec3* in, rmReal f );
void    RVec3Cross( RVec3* out, const RVec3* v1, const RVec3* v2 );

rmReal  RVec3Length( const RVec3* in );
rmReal  RVec3LengthSq( const RVec3* in );

rmReal  RVec3Dot( const RVec3* v1, const RVec3* v2 );

void    RVec3Copy( RVec3* out, const RVec3* in );
void    RVec3Normalize( RVec3* out, const RVec3* in );

void    RVec3Transform( struct RVec4* out, const struct RMtx4* m, const RVec3* in );
void    RVec3TransformCoord( RVec3* out, const struct RMtx4* m, const RVec3* in );
void    RVec3TransformNormal( RVec3* out, const struct RMtx4* m, const RVec3* in );
void    RVec3TransformRS( RVec3* out, const struct RMtx3* m, const RVec3* in );
void    RVec3TransformRSTransposed( RVec3* out, const struct RMtx3* m, const RVec3* in );
void    RVec3TransformByQuaternion( RVec3* out, const struct RQuat* q, const RVec3* in );

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
