json.extract! @user, :id, :nickname, :created_at, :updated_at, :accepted, :rejected, :money, :game_id, :is_blocking, :is_allowing, :is_active

json.ready_to_go @user.game.is_built