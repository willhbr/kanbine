# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resource :kanbine, only: :none do
  post 'issues/update_status_position', to: 'kanbine/issues#update_status_position'
  post 'projects/:id/settings', to: 'kanbine/settings#settings', as: 'settings'
end

get 'projects/:id/kanban(/version/:version_id)', to: 'kanban#show', as: 'kanbine'
