
with recurs_subds as (
    select id, name, parent_id, 0 as sub_level
    from subdivisions
    where id = (select subdivision_id from collaborators where id = 710253)

    union all

    select subdivisions.id, subdivisions.name, subdivisions.parent_id, recurs_subds.sub_level + 1
    from subdivisions 
    inner join recurs_subds on subdivisions.parent_id = recurs_subds.id
)


select  collaborators.id, 
        collaborators.name, 
        recurs_subds.name as sub_name, 
        recurs_subds.id as sub_id, 
        recurs_subds.sub_level, 
        count(collaborators.id) over (partition by recurs_subds.id) as colls_count
from recurs_subds 
left join collaborators on collaborators.subdivision_id = recurs_subds.id
where collaborators.age < 40 and recurs_subds.sub_level <> 0 and recurs_subds.id not in (100055, 100059)
order by recurs_subds.sub_level