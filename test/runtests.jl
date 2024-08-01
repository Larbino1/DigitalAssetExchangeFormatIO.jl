using DigitalAssetExchangeFormatIO
using FileIO
using Test
using UUIDs

FileIO.add_format(format"DAE", (), ".dae", [:DigitalAssetExchangeFormatIO => UUID("43182933-f65b-495a-9e05-4d939cea427d")])

@testset "DigitalAssetExchangeFormatIO.jl" begin
    # Write your tests here.
    for path in readdir("./meshes")
        if endswith(path, ".dae")
            fullpath= ("./meshes/$path")
            @testset "$fullpath" begin
                dae = load(fullpath)
            end
        end
    end
end
