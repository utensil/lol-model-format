/* -*- C -*- */
#ifndef RMATHMTX3_H_INCLUDED
#define RMATHMTX3_H_INCLUDED

#include "RType.h"

struct RVec3;
struct RQuat;

typedef struct RMtx3
{
    union
    {
        /* NOTE : column-major */
        struct
        {
            rmReal e00, e10, e20;
            rmReal e01, e11, e21;
            rmReal e02, e12, e22;
        };
        rmReal e[9];
    };
} RMtx3;

#ifdef __cplusplus
extern "C" {
#endif

void RMtx3SetElements( RMtx3* out,
                       rmReal e00, rmReal e01, rmReal e02,
                       rmReal e10, rmReal e11, rmReal e12,
                       rmReal e20, rmReal e21, rmReal e22
    );

void    RMtx3SetElement( RMtx3* out, int row, int col, rmReal e );
rmReal  RMtx3GetElement( const RMtx3* in, int row, int col );

void    RMtx3GetRow( struct RVec3* out, const RMtx3* in, int row );
void    RMtx3GetColumn( struct RVec3* out, const RMtx3* in, int col );

void    RMtx3SetRow( struct RMtx3* out, const RVec3* in, int row );
void    RMtx3SetColumn( struct RMtx3* out, const RVec3* in, int col );

void    RMtx3Copy( RMtx3* out, const RMtx3* in );

void    RMtx3Zero( RMtx3* out );
void    RMtx3Identity( RMtx3* out );
rmReal  RMtx3Determinant( const RMtx3* in );
void    RMtx3Transpose( RMtx3* out, const RMtx3* in );
rmReal  RMtx3Inverse( RMtx3* out, const RMtx3* in );

void    RMtx3RotationX( RMtx3* out, rmReal radian );
void    RMtx3RotationY( RMtx3* out, rmReal radian );
void    RMtx3RotationZ( RMtx3* out, rmReal radian );
void    RMtx3RotationAxis( RMtx3* out, const struct RVec3* axis, rmReal radian );
void    RMtx3RotationQuaternion( RMtx3* out, const struct RQuat* q );
void    RMtx3Scaling( RMtx3* out, rmReal sx, rmReal sy, rmReal sz );

int     RMtx3Equal( const RMtx3* m1, const RMtx3* m2 );

void    RMtx3Add( RMtx3* out, const RMtx3* m1, const RMtx3* m2 );
void    RMtx3Sub( RMtx3* out, const RMtx3* m1, const RMtx3* m2 );
void    RMtx3Mul( RMtx3* out, const RMtx3* m1, const RMtx3* m2 );
void    RMtx3Scale( RMtx3* out, const RMtx3* m, rmReal f );

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
