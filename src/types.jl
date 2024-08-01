struct DAEScene
    library_effects::Dict{String, Any}
    library_materials::Dict{String, Any}
    library_geometries::Dict{String, Any}
    library_visual_scenes::Dict{String, Any}
end

struct PhongShadingParams
    emmission::Union{Nothing, RGBA{Float32}}
    ambient::Union{Nothing, RGBA{Float32}}
    diffuse::Union{Nothing, RGBA{Float32}}
    specular::Union{Nothing, RGBA{Float32}}
    shininess::Union{Nothing, Float32}
    reflective::Union{Nothing, RGBA{Float32}}
    reflectivity::Union{Nothing, Float32}
    transparent::Union{Nothing, RGBA{Float32}}
    transparency::Union{Nothing, Float32}
end

struct LambertShadingParams
    emmission::Union{Nothing, RGBA{Float32}}
    ambient::Union{Nothing, RGBA{Float32}}
    diffuse::Union{Nothing, RGBA{Float32}}
    reflective::Union{Nothing, RGBA{Float32}}
    reflectivity::Union{Nothing, Float32}
    transparent::Union{Nothing, RGBA{Float32}}
    transparency::Union{Nothing, Float32}
    index_of_refraction::Union{Nothing, Float32}
end
