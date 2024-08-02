# DigitalAssetExchangeFormatIO

[![Build Status](https://github.com/Larbino1/DigitalAssetExchangeFormatIO.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Larbino1/DigitalAssetExchangeFormatIO.jl/actions/workflows/CI.yml?query=branch%3Amain)

An incomplete parser for `.dae` files. Was built to load meshes for a robot model to visualize
the model using GLMakie, and thus supports a small subset of the features of the format, enough
to load simple meshes, materials and visual scenes.

Notably it does NOT support light sources, cameras, or textures, but contributions are welcome!

To enable DAE loading with FileIO you must run 
```
using FileIO
using UUIDs
FileIO.add_format(format"DAE", (), ".dae", [:DigitalAssetExchangeFormatIO => UUID("43182933-f65b-495a-9e05-4d939cea427d")])
```
which will return a DAEScene.

COLLADA standard:
[https://www.khronos.org/files/collada_spec_1_5.pdf]
