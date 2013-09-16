module GraphHelper

  def category_to_node(category)
    { "name" => category.name,
      "url" => category_path(category.id),
      "category_id" =>category.id,
      "friends" => category.friends.map { |f| { "source" => category.id, "target" => f.id } },
      "children"   => category.children.map { |c| category_to_node(c) } # uncomment to add concept leafs # + category.concepts.map { |c| concept_to_node(c) }
    }
  end

  def concept_to_node(concept)
    { "name" => concept.name,
      "size"   => concept.lessons.size + concept.evaluators.size
    }
  end

  def concept_prereq_graph(concept)
    {
      "name" => concept.name,
      "concept_id" =>concept.id,
      "children"   => concept.prereqs.map { |c| concept_prereq_graph(c) }
    }
  end

  def concept_postreq_graph(concept)
    {
      "name" => concept.name,
      "concept_id" =>concept.id,
      "children"   => concept.postreqs.map { |c| concept_postreq_graph(c) }
    }
  end

end
