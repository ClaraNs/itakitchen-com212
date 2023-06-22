import { Component } from '@angular/core';
import { AlertController, IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';

/**
 * Generated class for the VerAvaliacaoPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-ver-avaliacao',
  templateUrl: 'ver-avaliacao.html',
})
export class VerAvaliacaoPage {

  estab: any = null;
  aval: any = null;
  excluir: any = false;

  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService,
    private toastCtrl:ToastController, private alertCtrl: AlertController) {
    this.aval = this.navParams.get('avaliacao');
    this.excluir = this.navParams.get('excluir');
    console.log(this.aval);
    this.carregarEstabelecimento();

  }

  confirmaExclusao() {
    const confirm = this.alertCtrl.create({
      title: 'Excluir Avaliação',
      message: 'Deseja mesmo excluir essa avaliação?',
      buttons: [
        {
          text: 'Não',
          handler: () => {

          }
        },
        {
          text: 'Sim',
          handler: () => {
            this.excluirAval();
          }
        }
      ]
    });
    confirm.present();
  }

  excluirAval(){
    this.share.excluirAvaliacao(this.aval.id).subscribe((data:any)=>{
      if(data == 1){
        let toast = this.toastCtrl.create({
          message: "Avaliação deletada com sucesso.",
          duration: 2000
        });
        toast.present();
        this.navCtrl.pop();
      }else{
        let toast = this.toastCtrl.create({
          message: "Algo deu errado.",
          duration: 2000
        });
        toast.present();
      }
    });
  }

  carregarEstabelecimento() {
    this.share.retornaEstabelecimentoPorID(this.aval.idestab).subscribe((data: any) => {
      console.log(data[0].id)
      this.share.retornaNumAvaliacoesPorEstab(data[0].id).subscribe((data2: any) => {

        let estab = {
          id: data[0].id,
          nome: data[0].nome,
          cnpj: data[0].cnpj,
          contato: data[0].contato,
          foto: data[0].foto,
          idendereco: data[0].idEndereco,
          idhorariofunc: data[0].idHorario,
          idcategoria: data[0].idCategoria,
          tipoarquivo: 'jpeg',
          numavaliacoes: data2[0][0],
          nota: data2[0][1],
          fotourl: 'data:image/' + 'png' + ';base64,' + data[0].foto
        }

        this.estab = estab;
      });

    });
  }

}
