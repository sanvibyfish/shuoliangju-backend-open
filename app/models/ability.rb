# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if @user.blank?
      roles_for_anonymous
    elsif @user.admin?
      can :manage, :all
      cannot %i[join], App
      can %i[join], App do |app|
        !Board.where(user_id: user.id, app_id: app.id).first.present?
      end
    elsif @user.normal?
      roles_for_members
    elsif @user.blocked?
      roles_for_anonymous
    else
      roles_for_anonymous
    end
  end

  protected

    # 未登录用户权限
    def roles_for_anonymous
      cannot :manage, :all
      basic_read_only
    end

    def roles_for_sections
      can :read, Section
    end

    def roles_for_groups
      can :create, Group
      can :destroy, Group do |group|
        group.user_id == user.id
      end
    end

    def roles_for_products
      can :create, Product
      can :destroy, Product do |product|
        product.user_id == user.id
      end
    end

    def roles_for_articles
      can %i[like unlike], Article
      can :create, Article do |article|
        if article.app.present?
          article.app.own_id = user.id
        else
          false
        end
      end
      can :destroy, Article do |article|
        article.user_id == user.id
      end
    end

    # 普通会员权限
    def roles_for_members
      roles_for_posts
      roles_for_groups
      roles_for_comments
      roles_for_users
      roles_for_notifications
      roles_for_sections
      roles_for_articles
      roles_for_apps
      roles_for_products
      basic_read_only
    end

    def roles_for_notifications
      can :manage, Notification
    end

    def roles_for_apps
      can :create, App do |app|
        # 去除白名单限制
        # user.actions.include?("create_app")
        true
      end
      can %i[join], App do |app|
        !Board.where(user_id: user.id, app_id: app.id).first.present?
      end
      can %i[exit], App do |app|
        Board.where(user_id: user.id, app_id: app.id).first.present?
      end
      can %i[update], App do |app|
        app.own_id == user.id
      end
    end

    #只读权限
    def basic_read_only
      can %i[read discover], Post
      can :read, Section
      can :read, Comment
      can :read, Article
      can :unread_counts, Notification
      can %i[read app_config members qrcode], App
      can :read, Group
      can %i[read show info following followers posts],User
      can :read, Product
    end

    def roles_for_posts
      can %i[star unstar like unlike qrcode], Post
      can %i[show], Post
      can %i[report], Post
      can :destroy, Post do |post|
        post.user_id == user.id
      end
      can :create, Post do |post|
        if post.section.present?
          if post.section.admin_role?
            post.section.admin_role? == user.admin?
          else
            true
          end
        else
          true
        end
      end
      can :manage, Post do |post|
        post.app.present? && post.app.own_id == user.id
      end
    end

    def roles_for_users
      can %i[update follow unfollow like_posts star_posts report], User
    end

    def roles_for_comments
      can :create, Comment
      can :destroy, Comment do |comment|
        comment.user_id == user.id
      end
      can %i[like unlike], Comment
      can :manage, Comment do |comment|
        comment.app.present? &&  comment.app.own_id == user.id
      end
    end 

end
