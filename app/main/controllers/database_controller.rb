module Main
  class DatabaseController < Volt::ModelController
    @status = false

    def enrollment
      self.model = store._databases.buffer
      model.paid = false
    end

    def payment
      self.model = store._databases.buffer
    end

    def swap_payment(id)
      store._databases.where(_id: id).first.then do |database|
        if database.paid
          database.update(paid: false)
          flash._warnings << 'Warning! Payment status reverted!'
        else
          database.update(paid: true)
          flash._successes << 'Payment status successfully changed!'
        end
      end
    end

    def change_status
      store._students.where(id_number: model._id_num).first.then do |student|
        if student.nil?
          model._sized = false
          flash._warnings << 'Student has not yet sized shirt!'
        else
          model._sized = true
          flash._successes << 'Successfull entry!'
        end
      end
      save
    end

    def change_payment
      store._databases.where(id_num: page._query).first.then do |database|
        update_student_registration
        database.update(paid: true).then do
          flash._successes << 'Payment modified!'
          page._query = ''
        end.fail do |errors|
          flash._errors << errors.to_s
        end
      end
    end

    def update_student_registration
      store._students.where(id_number: page._query).first.then do |student|
        if student.nil?
          flash._warnings << 'Student has not yet sized!'
        else
          student.update(paid: true)
        end
      end
    end

    def searched_enrollees
      query = { '$regex' => page._query || '', '$options' => 'i' }
      store._databases.where(id_num: query).order(['$natural', -1])
    end

    def paginated_enrollees
      searched_enrollees.skip(current_page * per_page).limit(per_page)
    end

    def current_page
      (params._page || 1).to_i - 1
    end

    def per_page
      15
    end

    def save
      model._sized = @status
        model.save!.then do
          enrollment
        end.fail do |errors|
          flash._errors << 'ID Number already encoded'
        end
    end
  end
end
