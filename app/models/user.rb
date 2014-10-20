class User < ActiveRecord::Base
    validates :userid, :uniqueness => true

    def self.authenticate(user, password)
        name = self.find_by_userid(user)
        if (name)
            if name.password != password
                name = nil
            end
        end
        name
    end
end
