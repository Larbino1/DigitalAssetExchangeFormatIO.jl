using DigitalAssetExchangeFormatIO
using FileIO
using Test
using UUIDs

FileIO.add_format(format"DAE", (), ".dae", [:DigitalAssetExchangeFormatIO => UUID("43182933-f65b-495a-9e05-4d939cea427d")])

@testset "DigitalAssetExchangeFormatIO.jl" begin
    # Write your tests here.
    for (rootpath, dirs, files) in walkdir("./meshes")
        for file in files
            dir = isempty(dirs) ? "" : joinpath(dirs)
            path=joinpath(rootpath, dir, file)
            @info "Testing loading $path"
            if endswith(path, ".dae")
                @testset "$path" begin
                    dae = load(path)
                    @test ~isnothing(dae)
                end
            end
        end
    end
end
