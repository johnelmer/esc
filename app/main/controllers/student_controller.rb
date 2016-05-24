module Main
  class StudentController < Volt::ModelController

    def new
      self.model = store._students.buffer
      model._claimed = false
      model._sized = true
      model._enrolled = false
    end

    def enrollment
      self.model = store._students.buffer
      page._id_number = ''
    end

    def edit
      store._students.where(_id: params._id).first.then do |student|
        student.update(sized: true)
        self.model = student.buffer
      end
    end

    def payment
      page._query = ''
    end

    def change_payment
      store._students.where(id_number: page._query).first.then do |student|
        if student.nil?
          flash._errors << 'Student not found!'
        else
          student.update(paid: true)
        end.then do
          payment
        end
      end
    end

    def swap_payment(id)
      store._students.where(_id: id).first.then do |student|
        if student.paid
          student.update(paid: false)
          flash._warnings << 'Warning! Payment status reverted!'
        else
          student.update(paid: true)
          flash._successes << 'Payment status successfully changed!'
        end
      end
    end

    def enroll
      store._students.where(id_number: page._id_number).first.then do |student|
        if student.nil?
          model._id_number = page._id_number
          model._enrolled = true
          model.save!.then do
            flash._warnings << 'Student has not sized shirt!'
          end
          enrollment
        else
          student.update(enrolled: true)
          enrollment
        end
      end
    end

    def swap_status(id)
      store._students.where(_id: id).first.then do |student|
        if student.claimed
          student.update(claimed: false)
          flash._warnings << 'Warning! Shirt status reverted!'
        else
          if student.paid
            student.update(claimed: true)
            flash._successes << 'Shirt successfully claimed!'
          else
            flash._errors << 'Please settle account balance!'
          end
        end
      end
    end

    def searched_enrollees
      query = { '$regex' => page._query || '', '$options' => 'i' }
      store._students.where({'$and' => [
        {id_number: query},
        {enrolled: true}
      ]}).order(['$natural', -1])
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
      model.save!.then do
        redirect_to '/all'
      end.fail do |error|
        flash._errors << error.to_s
      end
    end
  end
end
