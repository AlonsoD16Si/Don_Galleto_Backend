const {query, QueryTypes} = require("../config/database");

class InsumoService {
    constructor(insumoModel) {
        this.insumoModel = insumoModel;
    }

    async createInsumo(data){
        return await this.insumoModel.create(data);
    }

    async getAllInsumos(){
        return await this.insumoModel.findAll();
    }
    async getInsumoById(id) {
        return await this.insumoModel.findByPk(id);
    }

    async updateInsumo(id, data) {
        const insumo = await this.insumoModel.findByPk(id);
        if (!insumo) return null;
        return await insumo.update(data);
    }
}

module.exports = InsumoService;