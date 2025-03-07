function convert_for_glmakie(dae_scene::DAEScene)
    (;library_effects, library_materials, library_geometries, library_visual_scenes) = dae_scene
    if isnothing(library_visual_scenes)
        # IF no visual scenes are found, we merge all of the geometries into
        # a single mesh, and return that
        return merge_meshes(getindex.(values(library_geometries), :mesh))
    else
        mesh_entries = [library_geometries[mesh_url] for (mesh_url, _) in library_visual_scenes]
        transforms = [matrix for (_, matrix) in library_visual_scenes]
        meshes = [transform_mesh(entry.mesh, matrix) for (entry, matrix) in zip(mesh_entries, transforms)]
        materials = [library_effects[library_materials[entry.material]] for entry in mesh_entries]
        ret = [
            begin
                if isa(material, PhongShadingParams)
                    kwargs = (;
                        color=isnothing(material.diffuse) ? RGBA{Float32}(1.0f0, 0.0f0, 1.0f0, 1.0f0) : material.diffuse,
                        specular=isnothing(material.shininess) ? 0.0f0 : material.shininess,
                        shininess=isnothing(material.reflectivity) ? 0.0f0 : material.reflectivity
                    )
                elseif isa(material, LambertShadingParams)
                    kwargs = (; 
                        color=isnothing(material.diffuse) ? RGBA{Float32}(1.0f0, 0.0f0, 1.0f0, 1.0f0) : material.diffuse,
                        specular=0.0f0, 
                        shininess= isnothing(material.reflectivity) ? 0.0f0 : material.reflectivity
                    )
                else
                    error("Unsupported material type: $(typeof(material))")
                end
                (mesh, kwargs)
            end
            for (mesh, material) in zip(meshes, materials)
        ]
        return ret
    end

end

function transform_mesh(mesh, matrix::Matrix)
    @assert size(matrix) == (4, 4)

    positions = GeometryBasics.coordinates(mesh)
    P = eltype(positions)
    positions_transformed = [P((matrix * vcat(v, 1))[1:3]...) for v in positions]
    
    if hasproperty(mesh, :normal)
        normals = mesh.normal
        normals_transformed = if normals isa Vector
            N = eltype(normals)
            # Concat with zero as normals are free vectors, avoiding translation
            normals_transformed = [N((matrix * vcat(v, 0))[1:3]...) for v in normals]
        elseif normals isa FaceView
            N = eltype(values(normals))
            normals_transformed = [N((matrix * vcat(v, 0))[1:3]...) for v in values(normals)]
            FaceView(normals_transformed, faces(normals))
        else
            error("Unsupported normals type: $(typeof(normals))")
        end
        return Mesh(positions_transformed, GeometryBasics.faces(mesh); normal=normals_transformed)
    end
    return Mesh(positions_transformed, GeometryBasics.faces(mesh))
end

# function merge_meshes(meshes)
#     # Concatenate all positions and normals
#     positions = vcat((GeometryBasics.coordinates(mesh) for mesh in meshes)...)
#     # Concatenate all face indices, and offset them appropriately
#     faces = let
#         faces_each = [GeometryBasics.faces(mesh) for mesh in meshes]
#         offsets = vcat(0, cumsum(length.([mesh.position for mesh in meshes])))
#         F = eltype(first(faces_each))
#         faces_combined = vcat(
#             [
#                 F[
#                     face .+ offset
#                     for face in faces
#                 ] 
#                 for (faces, offset) in zip(faces_each, offsets)
#             ]
#         )
#         vcat(faces_combined...)
#     end
#     Mesh(positions, faces)
# end
