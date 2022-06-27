module DashboardHelper

    def random_chartkick_id
        return 'chart-#'+(Random.rand(10000)).to_s
      end
end
