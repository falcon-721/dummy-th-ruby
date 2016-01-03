class ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  class << self
    def alias_all(*methods, **hargs)
      to = hargs.fetch(:to)

      _policy_aliases_module.module_eval do
        methods.each do |method|
          define_method(method) do |*args|
            send(to, *args)
          end
        end
      end
    end

    def _policy_aliases_module # :nodoc:
      @_policy_aliases_module ||= begin
         mod = Module.new
         include mod
         mod
       end
    end
  end

  attr_reader :user, :target

  def initialize(user, target)
    @user = user
    @target = target
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user?
  end

  def update?
    manage?
  end

  def destroy?
    update?
  end

  def manage?
    user? && author?
  end

  protected

  def user?
    user.present?
  end

  def author?(obj = target)
    user.id == obj.user_id
  end

  def policy_for(obj)
    Pundit.policy(user, obj)
  end
end
