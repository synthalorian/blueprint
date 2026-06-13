class BlueprintDetailSerializer
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
      yaml_content: @blueprint.yaml_content,
      user: {
        name: @blueprint.user.name,
        slug: @blueprint.user.to_slug
      },
      packages: @blueprint.packages.map { |p| { name: p.name, category: p.category, version: p.version } },
      dotfiles: @blueprint.dotfiles.map { |d| { name: d.name, target_path: d.target_path } },
      environment_variables: @blueprint.environment_variables.map { |e| { key: e.key, value: e.value } },
      services: @blueprint.services.map { |s| { name: s.name, enabled: s.enabled } },
      created_at: @blueprint.created_at,
      updated_at: @blueprint.updated_at
    }
  end
end
