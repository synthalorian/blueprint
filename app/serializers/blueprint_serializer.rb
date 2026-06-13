class BlueprintSerializer
  def initialize(blueprint)
    @blueprint = blueprint
  end

  def as_json(*)
    {
      id: @blueprint.id,
      name: @blueprint.name,
      slug: @blueprint.slug,
      description: @blueprint.description,
      public: @blueprint.public,
      user: {
        name: @blueprint.user.name,
        slug: @blueprint.user.to_slug
      },
      created_at: @blueprint.created_at,
      updated_at: @blueprint.updated_at
    }
  end
end
