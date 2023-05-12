class ProductsController < ApplicationController
  include JsonWebToken
  before_action :authenticate_user 
  before_action :get_product, only: [:show, :update, :destroy]
  before_action :set_price_if_quantity_zero

  def index
    products = Product.all
    if params[:search_name].present?
      products = products.where(name: params[:search_name])
    elsif params[:search_name].present? && params[:sort_by] == 'asc'
      products = products.where(name: params[:search_name]).order(:price)
    elsif params[:sort_by] == 'asc'
      products = products.order(:price)
    elsif params[:sort_by] == 'desc'
      products = products.order(:price).reverse
    end
    raise('No products added yet') if products.blank?
    if products.present?
      products = Kaminari.paginate_array(products).page(params[:page] || 1).per(params[:per_page] || 10)
      render json: products, each_serializer: ProductSerializer, meta: { pagination: SerializeHelper.pagination_dict(products) }, status: :ok
    end
    # render json: products,each_serializer: ProductSerializer
  end
  
  def create
    product = Product.new(product_params)
    if product.save
      render json: { code: 200, product: ProductSerializer.new(product, include: [:images]).serializable_hash }
    else
      render json: { errors: [{ product: product.errors.full_messages }] }, status: :unprocessable_entity
    end
  end

  def show
    if @product.present?
      render json: {product: ProductSerializer.new(@product)}
    else
      render json: {errors: "product is not found"} 
    end
  end

  def update
    if @product.present?
      @product.update(product_params)
      render json:  ProductSerializer.new(@product).serializable_hash, status: :ok
    else
      render json: {errors: [{product: @product.errors.full_messages}]},  status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    render json: {code: 200, message: "Successfully deleted"}
  end

  private
  def get_product
    @product = Product.find_by(id: params[:id])
  end

  def set_price_if_quantity_zero
    self.price = 0 if Product.all.count==0
  end

  def authenticate_user
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?
    begin
      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
      @current_user_id = decoded[0]['user_id']
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :category_id, :image)
    # params.require(:product).permit(:name, :price, :description, :category_id, images_attributes: [:name, :image])
  end
end
