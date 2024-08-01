function convert_for_glmakie(dae_scene::DAEScene)
    (;library_effects, library_materials, library_geometries, library_visual_scenes) = dae_scene

    @show keys(library_effects)
    @show keys(library_materials)

    if isnothing(library_visual_scenes)
        # IF no visual scenes are found, we merge all of the geometries into
        # a single mesh, and return that
        return merge_meshes(getindex.(values(library_geometries), :mesh))
    else
        mesh_entries = [library_geometries[mesh_url] for (mesh_url, _) in library_visual_scenes]
        transforms = [matrix for (_, matrix) in library_visual_scenes]
        meshes = [transform_mesh(entry.mesh, matrix) for (entry, matrix) in zip(mesh_entries, transforms)]
        colors = [library_effects[library_materials[entry.material]].diffuse for entry in mesh_entries]
        return (meshes, colors)
    end

end

function transform_mesh(mesh, matrix)
    vals = split(content(matrix), " ")
    T = zeros(Float32, 4, 4)
    for i in 1:4
        for j in 1:4
            T[i, j] = parse(Float32, vals[(i - 1) * 4 + j])
        end
    end

    positions = GeometryBasics.metafree(GeometryBasics.coordinates(mesh))
    P = eltype(positions)
    positions_transformed = [P((T * vcat(v, 1))[1:3]...) for v in positions]
    
    if hasproperty(mesh, :normals)
        normals = GeometryBasics.normals(mesh)
        N = eltype(normals)
        # Concat with zero as normals are free vectors, avoiding translation
        normals_transformed = [N((T * vcat(v, 0))[1:3]...) for v in normals]
        return Mesh(meta(positions_transformed; normals=normals_transformed), GeometryBasics.faces(mesh))
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
